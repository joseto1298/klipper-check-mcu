#!/bin/bash
set -e

REPO_DIR="$HOME/klipper-check-mcu"

echo "=== Instalando klipper-check-mcu ==="

chmod +x "$REPO_DIR/check_mcu.sh"

# --- Instalar override systemd ---
echo "[1/2] Instalando override systemd..."
sudo mkdir -p /etc/systemd/system/klipper.service.d
sudo tee /etc/systemd/system/klipper.service.d/check-mcu.conf > /dev/null <<EOF
[Service]
ExecCondition=/bin/bash $REPO_DIR/check_mcu.sh
EOF
echo "OK"

# --- Añadir update_manager a moonraker.conf ---
echo "[2/2] Añadiendo update_manager a moonraker.conf..."
MOONRAKER_CFG="$HOME/printer_data/config/moonraker.conf"
if [ -f "$MOONRAKER_CFG" ]; then
    if grep -q "\[update_manager klipper-check-mcu\]" "$MOONRAKER_CFG"; then
        echo "OK (ya existe)"
    else
        echo "" >> "$MOONRAKER_CFG"
        cat "$REPO_DIR/.moonraker.conf" >> "$MOONRAKER_CFG"
        echo "OK (añadido)"
    fi
else
    cp "$REPO_DIR/.moonraker.conf" "$MOONRAKER_CFG"
    echo "OK (creado nuevo)"
fi

echo "=== Instalación completa ==="
