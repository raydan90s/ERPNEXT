# ==============================================================================
# ERPNext Docker - Script de Detencion
# ==============================================================================
# Uso:
#   .\docker-stop.ps1            - Detiene (datos persistentes)
#   .\docker-stop.ps1 -Clean     - Detiene y ELIMINA todos los datos
# ==============================================================================

param(
    [switch]$Clean
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  ERPNext Docker - Deteniendo servicios..." -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

if ($Clean) {
    Write-Host "ATENCION: Se eliminaran TODOS los datos." -ForegroundColor Red
    $confirm = Read-Host "Estas seguro? Escribe SI para confirmar"
    if ($confirm -ne "SI") {
        Write-Host "Operacion cancelada." -ForegroundColor Yellow
        exit 0
    }
    Write-Host ""
    Write-Host "Deteniendo contenedores y eliminando volumenes..." -ForegroundColor Yellow
    docker compose down -v
} else {
    Write-Host "Deteniendo contenedores (los datos se mantienen)..." -ForegroundColor Yellow
    docker compose down
}

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Green
    Write-Host "  ERPNext se detuvo correctamente." -ForegroundColor Green
    Write-Host "============================================================" -ForegroundColor Green
    Write-Host ""
    if (-not $Clean) {
        Write-Host "  Para reiniciar: .\docker-start.ps1" -ForegroundColor DarkGray
        Write-Host "  Para limpiar:   .\docker-stop.ps1 -Clean" -ForegroundColor DarkGray
        Write-Host ""
    }
} else {
    Write-Host ""
    Write-Host "ERROR: Hubo un problema al detener." -ForegroundColor Red
    exit 1
}
