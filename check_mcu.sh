#!/bin/bash
# check_mcu.sh - Bloquea el arranque de Klipper si el MCU de la impresora no está presente

CHECK_MCU_DELAY=${CHECK_MCU_DELAY:-5}
PRINTER_CFG="$HOME/printer_data/config/printer.cfg"

sleep "$CHECK_MCU_DELAY"

if [ ! -f "$PRINTER_CFG" ]; then
    logger -t check-mcu "ERROR: No se encontró $PRINTER_CFG"
    exit 1
fi

MCU=$(grep "/dev/serial/by-id/" "$PRINTER_CFG" | head -1 | sed 's/^serial:[[:space:]]*//')

if [ -z "$MCU" ]; then
    logger -t check-mcu "No se encontró serial MCU en $PRINTER_CFG"
    exit 1
fi

if [ ! -e "$MCU" ]; then
    logger -t check-mcu "MCU no encontrado: $MCU (dispositivo no conectado)"
    exit 1
fi

exit 0
