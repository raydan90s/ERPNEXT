# ==============================================================================
# ERPNext + SRI Docker - Script de Inicio
# ==============================================================================

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  ERPNext + SRI Docker - Iniciando servicios..." -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

try {
    docker info | Out-Null
} catch {
    Write-Host "ERROR: Docker no esta corriendo." -ForegroundColor Red
    Write-Host "Por favor inicia Docker Desktop y vuelve a intentarlo." -ForegroundColor Yellow
    exit 1
}

$port = "8080"
if (Test-Path ".env") {
    $envContent = Get-Content ".env" | Where-Object { $_ -match "^HTTP_PORT=" }
    if ($envContent) {
        $port = ($envContent -split "=")[1].Trim()
    }
}

$imageExists = docker images -q erpnext-sri 2>$null
if (-not $imageExists) {
    Write-Host "Imagen erpnext-sri no encontrada. Construyendo..." -ForegroundColor Yellow
    Write-Host "(Esto puede tardar varios minutos la primera vez)" -ForegroundColor DarkGray
    Write-Host ""
    docker compose build
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Fallo la construccion de la imagen." -ForegroundColor Red
        exit 1
    }
    Write-Host ""
}

Write-Host "Levantando contenedores..." -ForegroundColor Yellow
Write-Host ""

docker compose up -d

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Green
    Write-Host "  ERPNext + SRI se esta iniciando correctamente!" -ForegroundColor Green
    Write-Host "============================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "  URL:        http://localhost:$port" -ForegroundColor White
    Write-Host "  Usuario:    Administrator" -ForegroundColor White
    Write-Host "  Password:   admin (o la definida en .env)" -ForegroundColor White
    Write-Host ""
    Write-Host "  Ver progreso:" -ForegroundColor Yellow
    Write-Host "    docker compose logs -f create-site" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  Detener:" -ForegroundColor Yellow
    Write-Host "    .\docker-stop.ps1" -ForegroundColor DarkGray
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "ERROR: Hubo un problema al iniciar." -ForegroundColor Red
    Write-Host "Revisa: docker compose logs" -ForegroundColor Yellow
    exit 1
}
