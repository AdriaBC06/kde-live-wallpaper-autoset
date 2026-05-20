#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="kde-live-wallpaper-autoset"
SCRIPT_NAME="apply-live-wallpaper"
PLUGIN_PACKAGE="plasma6-wallpapers-smart-video-wallpaper-reborn"

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

have() {
  command -v "$1" >/dev/null 2>&1
}

install_package() {
  local package="$1"

  if pacman -Q "$package" >/dev/null 2>&1; then
    return 0
  fi

  if pacman -Si "$package" >/dev/null 2>&1; then
    sudo pacman -S --needed --noconfirm "$package"
    return 0
  fi

  if have yay; then
    yay -S --needed --noconfirm "$package"
    return 0
  fi

  die "package '${package}' was not found with pacman and yay is not installed"
}

if [[ "${EUID}" -eq 0 ]]; then
  die "run this installer as your normal user, not as root"
fi

if ! have pacman; then
  die "this installer currently supports Arch-based systems with pacman"
fi

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

install_package python
install_package findutils
install_package qt6-tools
install_package "$PLUGIN_PACKAGE"

mkdir -p "${HOME}/.local/bin" "${HOME}/.config/systemd/user" "${HOME}/LiveWallpaper"
install -m 0755 "${repo_dir}/src/${SCRIPT_NAME}" "${HOME}/.local/bin/${SCRIPT_NAME}"

cat > "${HOME}/.config/systemd/user/apply-live-wallpaper.service" <<UNIT
[Unit]
Description=Apply video from ~/LiveWallpaper as KDE live wallpaper
After=plasma-plasmashell.service
Wants=plasma-plasmashell.service

[Service]
Type=oneshot
ExecStart=${HOME}/.local/bin/${SCRIPT_NAME}

[Install]
WantedBy=graphical-session.target
UNIT

cat > "${HOME}/.config/systemd/user/apply-live-wallpaper.path" <<UNIT
[Unit]
Description=Watch ~/LiveWallpaper for KDE live wallpaper videos

[Path]
PathChanged=${HOME}/LiveWallpaper
PathModified=${HOME}/LiveWallpaper
Unit=apply-live-wallpaper.service

[Install]
WantedBy=graphical-session.target
UNIT

systemctl --user daemon-reload
systemctl --user enable apply-live-wallpaper.service
systemctl --user enable --now apply-live-wallpaper.path
systemctl --user start apply-live-wallpaper.service || true

printf '%s installed.\n' "$PROJECT_NAME"
printf 'Put an mp4/webm/mkv/mov/avi/m4v/gif in: %s/LiveWallpaper\n' "$HOME"
printf 'The newest supported video in that folder will be applied automatically.\n'
