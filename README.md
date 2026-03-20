# hyprland-entorno-nuevo

Repositorio para reconstruir tu entorno Hyprland con dotfiles y scripts de instalación automática.

## ¿Qué contiene?

- `dots/` → archivos que se copian a tu `$HOME`.
  - `dots/.config/Ax-Shell`
  - `dots/.config/hypr`
  - `dots/.config/kitty`
  - `dots/.config/nvim`
  - `dots/.local/bin` (scripts locales personalizados)
- `packages/` → listas de paquetes a instalar.
  - `core-pacman.txt` (repos oficiales)
  - `aur.txt` (AUR)
- `scripts/` → automatización de instalación y despliegue.

## ¿Cómo funciona el flujo?

1. `scripts/install-packages.sh`
	- Actualiza sistema (`pacman -Syu`)
	- Instala paquetes de `packages/core-pacman.txt`
	- Detecta `paru`/`yay` (o instala `yay-bin` si falta)
	- Instala AUR de `packages/aur.txt`
	- Habilita servicios clave: `NetworkManager`, `bluetooth`, `power-profiles-daemon`

2. `scripts/deploy-dots.sh`
	- Copia `dots/` hacia `$HOME`
	- **Sobrescribe** rutas de destino homónimas (`.config`, `.local`, etc.)
	- Recarga Hyprland (`hyprctl reload`)
	- Reinicia Ax-Shell

3. `scripts/rebuild-env.sh`
	- Ejecuta ambos scripts en orden: instalación + despliegue

4. `scripts/bootstrap.sh`
	- Clona/actualiza este repo automáticamente
	- Lanza `scripts/rebuild-env.sh`

## Instalación manual

```bash
bash scripts/install-packages.sh
bash scripts/deploy-dots.sh
```

## Instalación automática en un solo comando

### Opción con `curl`

```bash
curl -fsSL https://raw.githubusercontent.com/crashoverrid3x/hyprland-entorno-nuevo/main/scripts/bootstrap.sh | bash
```

### Opción con `wget`

```bash
wget -qO- https://raw.githubusercontent.com/crashoverrid3x/hyprland-entorno-nuevo/main/scripts/bootstrap.sh | bash
```

## Requisitos

- Arch Linux (usa `pacman` + AUR)
- Usuario con `sudo`
- Conexión a Internet
- Ejecutar **sin root**

## Personalización rápida

- Cambia paquetes en `packages/core-pacman.txt` y `packages/aur.txt`.
- Ajusta configs en `dots/.config/*`.
- Si no quieres desplegar `.local`, elimina esa carpeta de `dots/` antes de ejecutar `deploy-dots.sh`.

## Nota de seguridad

Como este repo ejecuta instalación de paquetes y copia dotfiles sobre tu HOME, revisa siempre los scripts antes de correrlos en otra máquina.