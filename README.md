# klipper-check-mcu

Impide que Klipper arranque si el MCU principal de la impresora no está presente.

Busca en `printer.cfg` el serial del MCU real (`/dev/serial/by-id/`), ignorando el host MCU virtual (`/tmp/klipper_host_mcu`). Si el device no existe, Klipper no arranca.

## Cómo funciona

- Systemd ejecuta `check_mcu.sh` como `ExecCondition=` antes de arrancar Klipper
- Busca la línea `serial:` que contenga `/dev/serial/by-id/` en `printer.cfg`
- Si el device no existe (impresora apagada), `exit 1` → `exec-condition` → Klipper **no arranca**, sin bucle de reinicios
- Si el device existe, `exit 0` → Klipper arranca normal

Para que arranque automáticamente al encender la impresora:

```ini
[power Ender-3-S1]
...
restart_klipper_when_powered: True
restart_delay: 3.0
```

Al encender desde la UI, Moonraker reinicia Klipper, `ExecCondition` pasa y arranca.

## Instalación

```bash
cd ~
git clone https://github.com/joseto1298/klipper-check-mcu.git
cd klipper-check-mcu
bash setup.sh
```

## Actualización

```bash
cd ~/klipper-check-mcu
git pull
```

Moonraker también actualiza automáticamente via update manager.

## Desinstalación

```bash
sudo rm /etc/systemd/system/klipper.service.d/check-mcu.conf
sudo systemctl daemon-reload
```
