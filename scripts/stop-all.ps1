# =============================================================================
# TLIA Marketing Stack - Stop All Services
# =============================================================================
# Usage: .\scripts\stop-all.ps1
# =============================================================================

Write-Host "Stopping TLIA Marketing Stack..." -ForegroundColor Cyan
Write-Host ""

Set-Location $PSScriptRoot\..

docker-compose down

Write-Host ""
Write-Host "All services stopped!" -ForegroundColor Green
Write-Host ""
Write-Host "Note: Data is preserved in Docker volumes." -ForegroundColor Gray
Write-Host "To remove all data, run: docker-compose down -v" -ForegroundColor Yellow
