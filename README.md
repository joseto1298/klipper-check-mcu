# klipper-check-mcu

Impide que Klipper arranque si el MCU principal de la impresora no está presente.

## Cómo funciona

- Systemd ejecuta `check_mcu.sh` como `ExecCondition=` antes de arrancar Klipper
- Si el MCU no está (impresora apagada), `exit 1` → Klipper **no arranca** — sin bucle de reinicios
- Para que arranque automáticamente al encender la impresora, tu `moonraker.conf` debe tener:

```ini
[power]
...
restart_klipper_when_powered: True
restart_delay: 3.0
```

Al encender la impresora desde la UI, Moonraker reinicia Klipper, `ExecCondition` pasa y arranca normal.

## Instalación

```bash
cd ~
git clone https://github.com/joseto1298/klipper-check-mcu.git
cd klipper-check-mcu
bash setup.sh
```

## Desinstalación

```bash
sudo rm /etc/systemd/system/klipper.service.d/check-mcu.conf
sudo systemctl daemon-reload
```
