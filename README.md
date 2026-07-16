# klipper-check-mcu

Impide que Klipper arranque si el MCU principal de la impresora no está presente.

Busca en `printer.cfg` el serial del MCU real (`/dev/serial/by-id/`), ignorando el host MCU virtual (`/tmp/klipper_host_mcu`). Si el device no existe, Klipper no arranca.

## Cómo funciona

- Systemd ejecuta `check_mcu.sh` como `ExecCondition=` antes de arrancar Klipper
- `sleep` configurable (default 5s) da tiempo a que aparezca el USB serial al encender la impresora
- Valida que `printer.cfg` existe
- Busca la línea `serial:` que contenga `/dev/serial/by-id/` en `printer.cfg`
- Si el device no existe (impresora apagada), `exit 1` → `exec-condition` → Klipper **no arranca**, sin bucle de reinicios
- Si el device existe, `exit 0` → Klipper arranca normal
- Los errores se registran en syslog

### Encendido automático de la impresora

Para que Klipper arranque al encender la impresora desde la UI, añade en `moonraker.conf`:

```ini
[power Ender-3-S1]
restart_klipper_when_powered: True
restart_delay: 3.0
```

Moonraker ejecuta `systemctl start klipper`, `ExecCondition=` espera 5s, el USB ya apareció, `exit 0` → Klipper arranca.

## Logging

Los errores se registran en syslog. Ver con:

```bash
journalctl -t check-mcu
```

## Instalación

```bash
cd ~
git clone https://github.com/joseto1298/klipper-check-mcu.git
cd klipper-check-mcu
sudo ./setup.sh
```

`setup.sh` necesita `sudo` para instalar el override systemd y corregir `workingDirectory` → `WorkingDirectory` en `klipper.service` (error conocido de Klipper).

## Actualización

```bash
cd ~/klipper-check-mcu
git pull
```

Moonraker también actualiza automáticamente via update manager.

## Configuración

### WorkingDirectory

Klipper define `workingDirectory` (minúscula) en su service file, pero systemd requiere `WorkingDirectory` (PascalCase). `setup.sh` corrige esto automáticamente. Si lo ves manualmente:

```bash
sudo sed -i 's/^workingDirectory=/WorkingDirectory=/' /etc/systemd/system/klipper.service
sudo systemctl daemon-reload
```

### Delay de espera

El delay de espera se puede ajustar añadiendo una variable de entorno en el override systemd:

```bash
sudo nano /etc/systemd/system/klipper.service.d/check-mcu.conf
```

```ini
[Service]
ExecCondition=/bin/bash /home/pi/klipper-check-mcu/check_mcu.sh
Environment=CHECK_MCU_DELAY=8
```

Luego:

```bash
sudo systemctl daemon-reload
```

> **Nota:** No uses `%h` en `ExecCondition` — klipper corre como root, así que `%h` resuelve a `/root` en vez de `/home/pi`.

## Desinstalación

```bash
sudo rm /etc/systemd/system/klipper.service.d/check-mcu.conf
sudo systemctl daemon-reload
```
