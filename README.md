# KDE Live Wallpaper Autoset

Automatically applies the newest video in `~/LiveWallpaper` as a KDE Plasma 6 live wallpaper.

This project is intended for Arch-based KDE Plasma systems, including Garuda Linux. It installs the Plasma 6 video wallpaper plugin, creates a user script, and enables systemd user units so the wallpaper is applied at login and whenever the `~/LiveWallpaper` folder changes.

## What It Does

- Creates `~/LiveWallpaper`.
- Watches that folder for changes.
- Picks the newest supported video file in that folder.
- Applies it through KDE Plasma using DBus.
- Leaves your current KDE wallpaper untouched if the folder has no supported video.
- Mutes the wallpaper audio.
- Loops the selected video.

Supported formats:

```text
mp4, mov, webm, mkv, avi, m4v, gif
```

The proprietary `.mlw` format from MyLiveWallpapers is not supported. Download or convert wallpapers to a normal video format such as `.mp4`.

## Requirements

- KDE Plasma 6
- Arch-based Linux distribution
- `pacman`
- `sudo`

Optional:

- `yay`, used as a fallback if a package is not available through configured pacman repositories.

The installer installs these packages when needed:

- `python`
- `findutils`
- `qt6-tools`
- `plasma6-wallpapers-smart-video-wallpaper-reborn`

## Install

```bash
git clone https://github.com/AdriaBC06/kde-live-wallpaper-autoset.git
cd kde-live-wallpaper-autoset
./install.sh
```

After installation, put a video file in:

```text
~/LiveWallpaper
```

The newest supported video in that folder will be applied automatically. You can also apply it manually:

```bash
systemctl --user start apply-live-wallpaper.service
```

## Change Wallpaper

Copy or move a new supported video into:

```text
~/LiveWallpaper
```

If there are multiple videos, the most recently modified one is used.

To keep a specific video selected, leave only that file in the folder or update its modification time:

```bash
touch ~/LiveWallpaper/video.mp4
```

## Check Status

```bash
systemctl --user status apply-live-wallpaper.service
systemctl --user status apply-live-wallpaper.path
```

Show recent logs:

```bash
journalctl --user -u apply-live-wallpaper.service -u apply-live-wallpaper.path --since today
```

## Uninstall

```bash
./uninstall.sh
```

The uninstaller removes the script and systemd user units. It keeps `~/LiveWallpaper` and does not reset your current KDE wallpaper.

## Notes

Video wallpapers render inside `plasmashell`, so CPU and memory usage will appear under the `plasmashell` process. Usage depends heavily on video resolution, codec, frame rate, and hardware acceleration.

For lower resource usage, prefer short H.264 `.mp4` files at 1080p or lower.

## License

GPL-3.0-only. See [LICENSE](LICENSE).
