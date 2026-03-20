#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACMAN_LIST="$ROOT_DIR/packages/core-pacman.txt"
AUR_LIST="$ROOT_DIR/packages/aur.txt"

if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
  echo "No ejecutes este script como root."
  exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
  echo "sudo no está disponible."
  exit 1
fi

if ! command -v pacman >/dev/null 2>&1; then
  echo "Este script está pensado para Arch Linux (pacman)."
  exit 1
fi

echo "[1/6] Sincronizando repositorios..."
sudo pacman -Syu --noconfirm

echo "[2/6] Resolviendo conflicto de audio (pipewire-pulse vs pulseaudio)..."
REMOVE_PKGS=()
for pkg in pulseaudio pulseaudio-alsa; do
  if pacman -Qq "$pkg" >/dev/null 2>&1; then
    REMOVE_PKGS+=("$pkg")
  fi
done
if (( ${#REMOVE_PKGS[@]} > 0 )); then
  sudo pacman -Rns --noconfirm "${REMOVE_PKGS[@]}"
fi

echo "[2/6] Instalando paquetes core (pacman)..."
mapfile -t PACMAN_PKGS < <(grep -vE '^\s*#|^\s*$' "$PACMAN_LIST")
sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"

echo "[3/6] Instalando helper AUR (yay si no existe)..."
if command -v paru >/dev/null 2>&1; then
  AUR_HELPER="paru"
elif command -v yay >/dev/null 2>&1; then
  AUR_HELPER="yay"
else
  TMP_DIR="$(mktemp -d)"
  git clone --depth=1 https://aur.archlinux.org/yay-bin.git "$TMP_DIR/yay-bin"
  (cd "$TMP_DIR/yay-bin" && makepkg -si --noconfirm)
  rm -rf "$TMP_DIR"
  AUR_HELPER="yay"
fi

echo "[4/6] Instalando paquetes AUR..."
mapfile -t AUR_PKGS < <(grep -vE '^\s*#|^\s*$' "$AUR_LIST")
"$AUR_HELPER" -S --needed --noconfirm --devel "${AUR_PKGS[@]}" || true

echo "[5/6] Servicios recomendados para este entorno..."
sudo systemctl enable --now NetworkManager || true
sudo systemctl enable --now bluetooth || true
sudo systemctl enable --now power-profiles-daemon || true

echo "[6/6] Listo. Ejecuta ahora scripts/deploy-dots.sh"
