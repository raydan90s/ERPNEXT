# ==============================================================================
# ERPNext Docker — Script de Inicio
# ==============================================================================
# Uso: .\docker-start.ps1
# ==============================================================================

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  ERPNext Docker — Iniciando servicios..." -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que Docker está corriendo
try {
    docker info | Out-Null
} catch {
    Write-Host "ERROR: Docker no está corriendo." -ForegroundColor Red
    Write-Host "Por favor inicia Docker Desktop y vuelve a intentarlo." -ForegroundColor Yellow
    exit 1
}

# Leer puerto del .env o usar default
$port = "8080"
if (Test-Path ".env") {
    $envContent = Get-Content ".env" | Where-Object { $_ -match "^HTTP_PORT=" }
    if ($envContent) {
        $port = ($envContent -split "=")[1].Trim()
    }
}

# Iniciar los contenedores
Write-Host "Descargando imagenes y levantando contenedores..." -ForegroundColor Yellow
Write-Host "(La primera vez puede tardar varios minutos)" -ForegroundColor DarkGray
Write-Host ""

docker compose up -d

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Green
    Write-Host "  ERPNext se esta iniciando correctamente!" -ForegroundColor Green
    Write-Host "============================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "  URL:        http://localhost:$port" -ForegroundColor White
    Write-Host "  Usuario:    Administrator" -ForegroundColor White
    Write-Host "  Password:   admin (o la definida en .env)" -ForegroundColor White
    Write-Host ""
    Write-Host "  NOTA: La primera vez, el sitio tarda ~2-3 minutos" -ForegroundColor Yellow
    Write-Host "  en crearse. Puedes ver el progreso con:" -ForegroundColor Yellow
    Write-Host "    docker compose logs -f create-site" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  Ver estado de todos los servicios:" -ForegroundColor Yellow
    Write-Host "    docker compose ps" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  Detener todo:" -ForegroundColor Yellow
    Write-Host "    .\docker-stop.ps1" -ForegroundColor DarkGray
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "ERROR: Hubo un problema al iniciar los contenedores." -ForegroundColor Red
    Write-Host "Revisa los logs con: docker compose logs" -ForegroundColor Yellow
    exit 1
}
