# ==============================================================================
# ERPNext + SRI Docker - Script de Build
# ==============================================================================

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  ERPNext + SRI - Construyendo imagen Docker..." -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

try {
    docker info | Out-Null
} catch {
    Write-Host "ERROR: Docker no esta corriendo." -ForegroundColor Red
    Write-Host "Por favor inicia Docker Desktop y vuelve a intentarlo." -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path "ErpSRI")) {
    Write-Host "ERROR: No se encontro la carpeta ErpSRI." -ForegroundColor Red
    exit 1
}

Write-Host "Construyendo imagen erpnext-sri..." -ForegroundColor Yellow
Write-Host "(Esto puede tardar varios minutos la primera vez)" -ForegroundColor DarkGray
Write-Host ""

docker compose build

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Green
    Write-Host "  Imagen erpnext-sri construida exitosamente!" -ForegroundColor Green
    Write-Host "============================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Para iniciar: .\docker-start.ps1" -ForegroundColor DarkGray
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "ERROR: Fallo la construccion de la imagen." -ForegroundColor Red
    Write-Host "Revisa los logs anteriores." -ForegroundColor Yellow
    exit 1
}
