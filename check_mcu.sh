#!/bin/bash
# check_mcu.sh - Bloquea el arranque de Klipper si el MCU de la impresora no está presente

MCU=$(grep "^serial:" "$HOME/printer_data/config/printer.cfg" | head -1 | sed 's/^serial:[[:space:]]*//')

if [ -z "$MCU" ] || [ ! -e "$MCU" ]; then
    exit 1
fi

exit 0
