# ==============================================================================
# ERPNext Docker — Script de Detención
# ==============================================================================
# Uso:
#   .\docker-stop.ps1            → Detiene los contenedores (datos persistentes)
#   .\docker-stop.ps1 -Clean     → Detiene y ELIMINA todos los datos
# ==============================================================================

param(
    [switch]$Clean
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  ERPNext Docker — Deteniendo servicios..." -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

if ($Clean) {
    Write-Host "ATENCION: Se eliminaran TODOS los datos (base de datos, sitios, logs)." -ForegroundColor Red
    $confirm = Read-Host "Estas seguro? Escribe 'SI' para confirmar"
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
        Write-Host "  Los datos estan guardados. Para reiniciar:" -ForegroundColor White
        Write-Host "    .\docker-start.ps1" -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  Para eliminar todos los datos:" -ForegroundColor Yellow
        Write-Host "    .\docker-stop.ps1 -Clean" -ForegroundColor DarkGray
        Write-Host ""
    } else {
        Write-Host "  Todos los datos fueron eliminados." -ForegroundColor White
        Write-Host "  La proxima vez que inicies se creara un sitio nuevo." -ForegroundColor DarkGray
        Write-Host ""
    }
} else {
    Write-Host ""
    Write-Host "ERROR: Hubo un problema al detener los contenedores." -ForegroundColor Red
    exit 1
}
