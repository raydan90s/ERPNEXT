# 🐳 ERPNext con Docker

Guía para levantar ERPNext localmente usando Docker.

## Requisitos

- [Docker Desktop](https://docs.docker.com/get-docker/) instalado y corriendo
- ~2 GB de espacio en disco (primera vez)

## Inicio Rápido

### Opción 1 — Script PowerShell

```powershell
.\docker-start.ps1
```

### Opción 2 — Comando directo

```powershell
docker compose up -d
```

### Acceder a ERPNext

| Dato | Valor |
|---|---|
| **URL** | http://localhost:8080 |
| **Usuario** | `Administrator` |
| **Contraseña** | `admin` |

> ⏳ **La primera ejecución tarda ~3-5 minutos** mientras descarga imágenes y crea el sitio.

### Ver progreso de creación del sitio

```powershell
docker compose logs -f create-site
```

### Ver estado de los servicios

```powershell
docker compose ps
```

## Detener ERPNext

### Detener (mantiene datos)

```powershell
.\docker-stop.ps1
# o: docker compose down
```

### Detener y limpiar TODO (elimina base de datos)

```powershell
.\docker-stop.ps1 -Clean
# o: docker compose down -v
```

## Configuración

Edita el archivo `.env` en la raíz del proyecto:

| Variable | Default | Descripción |
|---|---|---|
| `ERPNEXT_VERSION` | `v16.5.0` | Versión de ERPNext |
| `DB_PASSWORD` | `admin` | Contraseña root MariaDB |
| `SITE_ADMIN_PASSWORD` | `admin` | Contraseña del Administrator |
| `HTTP_PORT` | `8080` | Puerto HTTP local |
| `PROXY_READ_TIMEOUT` | `120` | Timeout del proxy (seg) |
| `CLIENT_MAX_BODY_SIZE` | `50m` | Tamaño máximo de upload |

## Servicios Docker

| Servicio | Descripción |
|---|---|
| `db` | MariaDB 10.6 — base de datos |
| `redis-cache` | Redis — caché |
| `redis-queue` | Redis — cola de trabajos |
| `configurator` | Inicializa configuración de Bench |
| `create-site` | Crea el sitio ERPNext (primera vez) |
| `backend` | Servidor de aplicación Frappe |
| `frontend` | Nginx reverse proxy |
| `websocket` | Socket.IO — tiempo real |
| `queue-short` | Worker — tareas cortas |
| `queue-long` | Worker — tareas largas |
| `scheduler` | Planificador de tareas |

## Solución de Problemas

### El sitio no carga

```powershell
# Ver logs del creador de sitio
docker compose logs create-site

# Ver logs del backend
docker compose logs backend

# Reiniciar todo
docker compose restart
```

### Puerto 8080 ocupado

Cambia `HTTP_PORT` en el archivo `.env`:
```env
HTTP_PORT=8888
```

### Reiniciar desde cero

```powershell
docker compose down -v
docker compose up -d
```
