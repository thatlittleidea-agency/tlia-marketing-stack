# =============================================================================
# TLIA Marketing Stack - Start All Services
# =============================================================================
# Usage: .\scripts\start-all.ps1
# =============================================================================

Write-Host "Starting TLIA Marketing Stack..." -ForegroundColor Cyan
Write-Host ""

Set-Location $PSScriptRoot\..

docker-compose up -d

Write-Host ""
Write-Host "All services started!" -ForegroundColor Green
Write-Host ""
Write-Host "Access URLs:" -ForegroundColor Yellow
Write-Host "  Mautic:      http://localhost:8080"
Write-Host "  N8N:         http://localhost:5678"
Write-Host "  EspoCRM:     http://localhost:8888"
Write-Host "  YOURLS:      http://localhost:8181"
Write-Host "  Matomo:      http://localhost:8282"
Write-Host "  Metabase:    http://localhost:3000"
Write-Host "  phpMyAdmin:  http://localhost:8090"
Write-Host ""
Write-Host "Run 'docker-compose ps' to check status" -ForegroundColor Gray
