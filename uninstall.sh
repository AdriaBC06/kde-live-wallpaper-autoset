#!/usr/bin/env bash
set -euo pipefail

systemctl --user disable --now apply-live-wallpaper.path >/dev/null 2>&1 || true
systemctl --user disable apply-live-wallpaper.service >/dev/null 2>&1 || true
systemctl --user reset-failed apply-live-wallpaper.path apply-live-wallpaper.service >/dev/null 2>&1 || true

rm -f "${HOME}/.config/systemd/user/apply-live-wallpaper.path"
rm -f "${HOME}/.config/systemd/user/apply-live-wallpaper.service"
rm -f "${HOME}/.local/bin/apply-live-wallpaper"

systemctl --user daemon-reload

printf 'Uninstalled kde-live-wallpaper-autoset.\n'
printf 'Kept your ~/LiveWallpaper folder and current KDE wallpaper configuration untouched.\n'
