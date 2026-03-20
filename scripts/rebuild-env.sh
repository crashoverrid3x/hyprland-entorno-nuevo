#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash "$ROOT_DIR/scripts/install-packages.sh"
bash "$ROOT_DIR/scripts/deploy-dots.sh"

echo "Entorno Hyprland restaurado."