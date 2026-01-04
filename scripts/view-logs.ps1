# =============================================================================
# TLIA Marketing Stack - View Service Logs
# =============================================================================
# Usage:
#   .\scripts\view-logs.ps1              # View all logs
#   .\scripts\view-logs.ps1 mautic       # View Mautic logs
#   .\scripts\view-logs.ps1 n8n          # View N8N logs
# =============================================================================

param(
    [Parameter(Position=0)]
    [string]$ServiceName
)

Set-Location $PSScriptRoot\..

$ValidServices = @("mautic", "mautic-db", "n8n", "espocrm", "espocrm-db", "yourls", "yourls-db", "matomo", "matomo-db", "metabase", "phpmyadmin")

if ([string]::IsNullOrEmpty($ServiceName)) {
    Write-Host "Viewing logs for all services..." -ForegroundColor Cyan
    Write-Host "Press Ctrl+C to exit" -ForegroundColor Gray
    Write-Host ""
    docker-compose logs -f --tail=50
}
elseif ($ValidServices -contains $ServiceName) {
    Write-Host "Viewing logs for $ServiceName..." -ForegroundColor Cyan
    Write-Host "Press Ctrl+C to exit" -ForegroundColor Gray
    Write-Host ""
    docker-compose logs -f --tail=100 $ServiceName
}
else {
    Write-Host "Invalid service name: $ServiceName" -ForegroundColor Red
    Write-Host ""
    Write-Host "Valid services:" -ForegroundColor Yellow
    $ValidServices | ForEach-Object { Write-Host "  - $_" }
}
