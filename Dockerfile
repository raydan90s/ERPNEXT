# ==============================================================================
# ERPNext + SRI — Imagen Docker personalizada
# ==============================================================================
# Construye una imagen basada en frappe/erpnext que incluye el módulo SRI
# para facturación electrónica del Ecuador.
#
# Build:  docker compose build
# Start:  docker compose up -d
# ==============================================================================

ARG ERPNEXT_VERSION=v16.5.0
FROM frappe/erpnext:${ERPNEXT_VERSION}

# Copiar la app SRI al bench (la estructura Frappe espera pyproject.toml + sri/)
USER root
COPY --chown=frappe:frappe ErpSRI/ /home/frappe/frappe-bench/apps/sri/

USER frappe
WORKDIR /home/frappe/frappe-bench

# Instalar la app SRI en el entorno virtual de bench y construir assets
RUN /home/frappe/frappe-bench/env/bin/pip install --no-cache-dir -e /home/frappe/frappe-bench/apps/sri \
    && bench build --app sri 2>/dev/null || true
