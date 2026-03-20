#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/crashoverrid3x/hyprland-entorno-nuevo.git}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/src/hyprland-entorno-nuevo}"

if ! command -v git >/dev/null 2>&1; then
  echo "git no está instalado. Instálalo primero y vuelve a ejecutar."
  exit 1
fi

mkdir -p "$(dirname "$INSTALL_DIR")"

if [[ -d "$INSTALL_DIR/.git" ]]; then
  echo "Actualizando repositorio en $INSTALL_DIR ..."
  git -C "$INSTALL_DIR" pull --ff-only
else
  echo "Clonando repositorio en $INSTALL_DIR ..."
  git clone --depth=1 "$REPO_URL" "$INSTALL_DIR"
fi

echo "Ejecutando instalación completa..."
bash "$INSTALL_DIR/scripts/rebuild-env.sh"

echo "Listo. Entorno instalado desde $INSTALL_DIR"
