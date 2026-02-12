# 🐳 ERPNext + SRI con Docker

Guía para levantar ERPNext con el módulo SRI (facturación electrónica Ecuador) usando Docker.

## Requisitos

- [Docker Desktop](https://docs.docker.com/get-docker/) instalado y corriendo
- ~3 GB de espacio en disco (primera vez)
- Repo `ErpSRI` clonado en la raíz del proyecto

## Inicio Rápido

### 1. Construir la imagen (primera vez)

```powershell
.\docker-build.ps1
# o: docker compose build
```

### 2. Levantar todo

```powershell
.\docker-start.ps1
# o: docker compose up -d
```

> ⏳ **La primera ejecución tarda ~5 min** mientras crea el sitio e instala ERPNext + SRI.

### 3. Acceder a ERPNext

| Dato | Valor |
|---|---|
| **URL** | http://localhost:8080 |
| **Usuario** | `Administrator` |
| **Contraseña** | `admin` |

### Ver progreso de instalación

```powershell
docker compose logs -f create-site
```

## Detener ERPNext

```powershell
.\docker-stop.ps1              # Mantiene datos
.\docker-stop.ps1 -Clean       # Elimina TODOS los datos
```

## Configuración (.env)

| Variable | Default | Descripción |
|---|---|---|
| `ERPNEXT_VERSION` | `v16.5.0` | Versión de ERPNext |
| `DB_PASSWORD` | `admin` | Contraseña root MariaDB |
| `SITE_ADMIN_PASSWORD` | `admin` | Contraseña del Administrator |
| `HTTP_PORT` | `8080` | Puerto HTTP local |

## Reconstruir imagen (después de cambios en SRI)

Si haces cambios en el código de `ErpSRI/`:

```powershell
docker compose build --no-cache
docker compose down -v
docker compose up -d
```

## Servicios Docker

| Servicio | Descripción |
|---|---|
| `db` | MariaDB 10.6 |
| `redis-cache/queue` | Redis |
| `configurator` | Inicializa bench |
| `create-site` | Crea sitio + instala ERPNext y **SRI** |
| `backend` | Servidor Frappe |
| `frontend` | Nginx (puerto 8080) |
| `websocket` | Socket.IO |
| `queue-short/long` | Workers |
| `scheduler` | Planificador |
