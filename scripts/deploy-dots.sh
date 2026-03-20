#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOTS_DIR="$ROOT_DIR/dots"
TARGET_HOME="${HOME}"

if [[ ! -d "$DOTS_DIR" ]]; then
  echo "No existe carpeta de dots: $DOTS_DIR"
  exit 1
fi

echo "Copiando dots a $TARGET_HOME ..."
DOTS_DIR="$DOTS_DIR" TARGET_HOME="$TARGET_HOME" python - <<'PY'
import os
import shutil

dots_dir = os.path.expanduser(os.environ["DOTS_DIR"])
target_home = os.path.expanduser(os.environ["TARGET_HOME"])

for entry in os.listdir(dots_dir):
  src = os.path.join(dots_dir, entry)
  dst = os.path.join(target_home, entry)

  if os.path.exists(dst):
    if os.path.isdir(dst) and not os.path.islink(dst):
      shutil.rmtree(dst)
    else:
      os.remove(dst)

  if os.path.isdir(src):
    shutil.copytree(src, dst, symlinks=True)
  else:
    shutil.copy2(src, dst)
PY

echo "Recargando Hyprland (si está activo)..."
hyprctl reload >/dev/null 2>&1 || true

echo "Intentando reiniciar Ax-Shell..."
pkill -f "Ax-Shell/main.py" >/dev/null 2>&1 || true
nohup python "$HOME/.config/Ax-Shell/main.py" >/tmp/ax-shell.log 2>&1 &

echo "Despliegue completado."
