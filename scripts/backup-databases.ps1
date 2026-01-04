# =============================================================================
# TLIA Marketing Stack - Backup All Databases
# =============================================================================
# Usage: .\scripts\backup-databases.ps1
# Backups are saved to: ./backups/
# =============================================================================

$ErrorActionPreference = "Stop"

Set-Location $PSScriptRoot\..

# Create timestamp for backup files
$Timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$BackupDir = ".\backups"

# Ensure backup directory exists
if (!(Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir | Out-Null
}

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "TLIA Marketing Stack - Database Backup" -ForegroundColor Cyan
Write-Host "Timestamp: $Timestamp" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# Load environment variables
if (Test-Path ".\.env") {
    Get-Content ".\.env" | ForEach-Object {
        if ($_ -match "^([^#][^=]+)=(.*)$") {
            [Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
        }
    }
}

# Database configurations
$Databases = @(
    @{Name="mautic"; Container="tlia-mautic-db"; Database="mautic"; PasswordVar="MAUTIC_DB_ROOT_PASSWORD"},
    @{Name="espocrm"; Container="tlia-espocrm-db"; Database="espocrm"; PasswordVar="ESPOCRM_DB_ROOT_PASSWORD"},
    @{Name="yourls"; Container="tlia-yourls-db"; Database="yourls"; PasswordVar="YOURLS_DB_ROOT_PASSWORD"},
    @{Name="matomo"; Container="tlia-matomo-db"; Database="matomo"; PasswordVar="MATOMO_DB_ROOT_PASSWORD"}
)

$SuccessCount = 0
$FailCount = 0

foreach ($db in $Databases) {
    $BackupFile = "$BackupDir\$($db.Name)_$Timestamp.sql"
    $Password = [Environment]::GetEnvironmentVariable($db.PasswordVar, "Process")

    Write-Host "Backing up $($db.Name)..." -ForegroundColor Yellow -NoNewline

    try {
        # Check if container is running
        $ContainerStatus = docker ps --filter "name=$($db.Container)" --format "{{.Status}}"

        if ($ContainerStatus) {
            docker exec $($db.Container) mysqldump -u root -p"$Password" $($db.Database) > $BackupFile 2>$null

            if (Test-Path $BackupFile) {
                $FileSize = (Get-Item $BackupFile).Length / 1KB
                Write-Host " OK ($([math]::Round($FileSize, 2)) KB)" -ForegroundColor Green
                $SuccessCount++
            } else {
                Write-Host " FAILED (No output)" -ForegroundColor Red
                $FailCount++
            }
        } else {
            Write-Host " SKIPPED (Container not running)" -ForegroundColor Gray
        }
    }
    catch {
        Write-Host " FAILED ($_)" -ForegroundColor Red
        $FailCount++
    }
}

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Backup Summary" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Successful: $SuccessCount" -ForegroundColor Green
Write-Host "Failed: $FailCount" -ForegroundColor $(if ($FailCount -gt 0) { "Red" } else { "Green" })
Write-Host "Location: $((Resolve-Path $BackupDir).Path)" -ForegroundColor Gray
Write-Host ""

# List backup files
Write-Host "Backup files:" -ForegroundColor Yellow
Get-ChildItem $BackupDir -Filter "*$Timestamp.sql" | ForEach-Object {
    Write-Host "  - $($_.Name)" -ForegroundColor Gray
}
