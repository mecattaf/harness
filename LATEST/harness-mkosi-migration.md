# Harness mkosi Migration Reference

Starting point: Zirconium mkosi (in `LATEST-ZIRCONIUM/`).
This document traces every delta needed to reach harness.

---

## A. Kept from Zirconium (unchanged)

### Build infrastructure

| File | Change |
|---|---|
| `mkosi.conf` | Only: `ImageId=Zirconium` -> `ImageId=harness` |
| `mkosi.prepare.chroot` | Kept as-is (extended with font downloads in harness) |
| `mkosi.bump`, `mkosi.clean` | Kept as-is |
| `Justfile` | Only: default image name `zirconium` -> `harness` |
| `.editorconfig`, `.gitignore` | Kept as-is |

### mkosi.conf.d/ files kept as-is

- `niri-git.conf` -- yalter/niri-git COPR, niri package, doc removal
- `non-rawhide.conf` -- enables updates-testing for non-rawhide
- `norecommends.conf` -- just + Qt theming deps (kf6-kimageformats, kf6-kirigami, kf6-qqc2-desktop-style, plasma-breeze)
- `subprojects.conf` -- ublue-brew overlay, luks-tpm2-autounlock, ublue-os just recipes
- `ublue-os-packages.conf` -- uupd from ublue-os/packages COPR

### Profiles kept as-is

- `bootc-ostree/` -- entire profile (OCI format, dracut initramfs, ostree fs layout, finalize)
- `fedora-bootc-ostree/` -- entire profile (bootloader, firmware, goodies, others, rhel-edge, postinst)

### mkosi.extra/ overlay files kept

- `etc/profile.d/fcitx5.sh` -- input method env vars
- `usr/lib/dracut/dracut.conf.d/lvm2.conf` -- LVM in initramfs
- `usr/lib/dracut/dracut.conf.d/passkeys.conf` -- passkey support in initramfs
- `usr/lib/pam.d/greetd-spawn` -- PAM config for greetd
- `usr/lib/systemd/system-preset/91-resolved-default.preset` -- systemd-resolved default
- `usr/lib/systemd/system-preset/99-no-nsresourced.preset` -- disable nsresourced
- `usr/lib/systemd/system/flatpak-add-flathub-repos.service` -- adds flathub remote
- `usr/lib/systemd/user/chezmoi-update.service` -- dotfile update service
- `usr/lib/systemd/user/chezmoi-update.timer` -- dotfile update timer
- `usr/lib/systemd/user/fcitx5.service` -- fcitx5 daemon
- `usr/lib/systemd/user/iio-niri.service` -- screen auto-rotation
- `usr/lib/systemd/user/udiskie.service` -- automount daemon
- `usr/lib/tmpfiles.d/resolved-default.conf` -- resolv.conf symlink
- `usr/share/greetd/greetd-spawn.pam_env.conf` -- PAM env for greetd

### Subprojects kept

- `subprojects/ublue-brew` (homebrew integration)
- `subprojects/bluefin-common` (luks-tpm2, ublue-os just recipes)

### mkosi.postinst.chroot logic kept

- Homebrew cache install (`homebrew.tar.zst`)
- Flathub remote install (`flathub.flatpakrepo`)
- Niri version verification (`niri --version | grep ...`)
- bootc-fetch-apply-updates quiet mode patch
- PAM gnome_keyring.so fix for greetd
- Font cache rebuild (`fc-cache --force --really-force --system-only`)
- Flathub/uupd/brew stat checks
- os-release rebranding pattern (adapted for harness)

### Shared packages (from Zirconium's theme.conf -> renamed to harness-desktop.conf)

All of these are kept:

```
bolt              brightnessctl     cava              chezmoi
ddcutil           default-fonts     default-fonts-core-emoji
fastfetch         fcitx5-mozc       flatpak           foot
fpaste            fzf               gcr               generic-logos
git-core          glibc-all-langpacks                 glycin-thumbnailer
gnome-disk-utility                  gnome-keyring     gnome-keyring-pam
gnupg2-scdaemon   google-noto-color-emoji-fonts       google-noto-emoji-fonts
greetd            greetd-selinux    gst-thumbnailers  input-remapper
khal              nano-default-editor                  nautilus
nautilus-python   ncurses           openssh-askpass    orca
pipewire          playerctl         qt6ct             qt6-qtmultimedia
steam-devices     tailscale         udiskie           webp-pixbuf-loader
wireplumber       wl-clipboard      wl-mirror         wtype
xdg-desktop-portal-gnome            xdg-desktop-portal-gtk
xdg-terminal-exec xdg-user-dirs    xorg-x11-server-Xwayland
xwayland-satellite                  ykman
```

### Shared RemovePackages (kept)

```
alacritty         fuzzel            mako
PackageKit        PackageKit-glib   qemu-user-static
swayidle          ublue-os-update-services             swaylock
waybar            ibus-panel        systemd-networkd
```

### Shared RemoveFiles (kept)

```
/usr/lib/systemd/system/flatpak-add-fedora-repos.service
/usr/bin/chsh
/usr/share/applications/fcitx5-wayland-launcher.desktop
/usr/share/applications/org.fcitx.Fcitx5*.desktop
```

---

## B. Not brought over from Zirconium

### Deleted mkosi.conf.d/ files

**`avengemedia-danklinux.conf`** -- entire file removed:
- Packages not used: dms, dms-cli, dms-greeter, dgop, dsearch, quickshell-git
- COPRs not used: avengemedia/danklinux, avengemedia/dms-git
- Harness uses quickshellX-git from mecattaf/harnessRPM instead

### Deleted profiles

- `nvidia/` -- entire profile (harness is AMD-only)

### Deleted repo files

- `repos/avengemedia-danklinux.repo`
- `repos/avengemedia-dms-git.repo`
- `repos/terra-nvidia.repo`

### Deleted subprojects/submodules

- `assets` -- Zirconium wallpapers/logos (harness has own branding)
- `mkosi.extra/usr/share/zirconium/zdots` -- replaced with `subprojects/dotfiles` -> mecattaf/dotfiles

### Deleted mkosi.extra/ overlay files

**Zirconium branding (all removed):**
- `etc/profile.d/zfetch.sh`
- `etc/profile.d/zmotd.sh`
- `usr/bin/glorpfetch`
- `usr/bin/zfetch`
- `usr/bin/zjust` (replaced with `usr/bin/hjust`)
- `usr/bin/zmotd`
- `usr/share/fish/vendor_conf.d/zmotd.fish`
- `usr/share/zirconium/` (entire directory: fastfetch.jsonc, glorp.txt, legally-distinct.txt, zirconium.txt, shell/pure.bash, just/00-start.just)

**DMS-specific (all removed):**
- `usr/lib/sysusers.d/dms-greeter.conf`
- `usr/lib/tmpfiles.d/99-dms-greeter.conf`
- `usr/share/dms/cli-policy.json`
- `usr/lib/systemd/system/flatpak-preinstall.service`
- `usr/share/flatpak/preinstall.d/zirconium.preinstall`

**Zirconium signing keys (replaced):**
- `usr/share/pki/containers/zirconium.pub` -> replaced with `harness.pub`
- `usr/share/pki/containers/jackrabbit.pub` -- removed
- `usr/share/pki/containers/hawaii.pub` -- removed

**Zirconium container config (replaced):**
- `etc/containers/policy.json` -> replaced with harness version (ghcr.io/mecattaf)
- `etc/containers/registries.d/zirconium-dev.yaml` -> replaced with `harness.yaml`

**Zirconium-specific config:**
- `etc/taidan.toml` -- first-run wizard (harness has no OOBE)

### Removed packages (Zirconium has, harness drops)

```
fcitx5-chinese-addons    (harness only needs fcitx5-mozc for Japanese)
fcitx5-rime              (Chinese input, not needed)
librime-lua              (Rime dependency, not needed)
hyfetch                  (replaced by fastfetch directly)
maple-fonts              (from terra -- harness has own font pipeline)
```

### Removed mkosi.postinst.chroot logic

- DMS PAM files install (`/usr/share/quickshell/dms/assets/pam/*`)
- Zirconium shell theme (`source /usr/share/zirconium/shell/pure.bash`)
- zjust completions (replaced with hjust)
- stat checks for zirconium.pub, jackrabbit.pub

### Removed preset entries

| Preset | Entry | Reason |
|---|---|---|
| System | `flatpak-preinstall.service` | DMS-based flatpak approach |
| User | `dms.service` | DMS greeter not used |
| User | `foot-server.service` | harness uses kitty |
| User | `foot-server.socket` | harness uses kitty |

---

## C. What harness adds

### New subprojects

- `subprojects/dotfiles` -> github.com/mecattaf/dotfiles (git submodule, replaces zdots; installed to `/usr/share/harness/dotfiles` via ExtraTrees)

### Renamed: theme.conf -> harness-desktop.conf

Zirconium's `theme.conf` is renamed to `harness-desktop.conf` for clarity. It carries forward all shared packages/removals from Section A, plus the additions and extra removals below.

### Additional packages added to harness-desktop.conf

```
kanshi            polkit            imv               vlc
xarchiver         zathura           zathura-pdf-poppler
ibus              fontawesome-fonts-all               gnome-icon-theme
google-noto-fonts-common            google-noto-sans-fonts
google-roboto-fonts                 overpass-fonts    overpass-mono-fonts
dbus-daemon       dbus-tools        gsettings-desktop-schemas
sox               unrar-free        wmctrl            ydotool
yt-dlp            radeontop         acpi              age
aria2             caddy
cockpit           cockpit-machines  cockpit-networkmanager
cockpit-podman    cockpit-selinux   cockpit-storaged  cockpit-system
pcp-zeroconf
bluez             bluez-tools       gvfs              pamixer
pipewire-alsa     pipewire-jack-audio-connection-kit  pipewire-pulseaudio
libcamera
mesa-dri-drivers  mesa-vulkan-drivers
vulkan-tools      vulkan-validation-layers
libva             libva-utils       libva-intel-media-driver
```

### Additional RemovePackages added to harness-desktop.conf

```
firefox           firefox-langpacks
virtualbox-guest-additions          nvtop             sway
yggdrasil         adcli
libdnf-plugin-subscription-manager
python3-subscription-manager-rhsm
subscription-manager
subscription-manager-rhsm-certificates
console-login-helper-messages       chrony            sssd*
```

### Modified terra.conf

Kept packages (removed only `maple-fonts`):
```
terra-release
terra-release-extras
xdg-terminal-exec-nautilus
iio-niri
valent
```

### New mkosi.conf.d/ files

**`harness-copr.conf`** -- mecattaf/harnessRPM COPR:
```
asr-rs            atuin             bibata-cursor-themes
cliamp            cliphist          eza               gws
kitty             lisgd             mactahoe-oled     nwg-look
pi                quickshellX-git   shpool            starship
wl-gammarelay-rs
```

**`harness-devtools.conf`** -- dev/AI packages:
```
cmake             cpio              dbus-x11          direnv
fish              gcc               gcc-c++           gh
git-credential-libsecret            git-lfs           libadwaita
make              meson             neovim            p7zip
pandoc            pipx              python3-cairo     python3-pip
ripgrep           uv                yq                zoxide
podman-compose    podman-tui        podmansh
ollama            ramalama          whisper-cpp
python3-gobject   python3-ijson     python3-numpy     python3-pillow
python3-psutil    python3-pywayland python3-ramalama  python3-requests
python3-setproctitle               python3-watchdog   tesseract
```

**`harness-extra-repos.conf`** -- non-COPR custom repos:
- Repos: tailscale.repo, antigravity.repo, google-cloud-cli.repo
- Packages: `antigravity`, `google-cloud-cli`, `libxcrypt-compat`

**`harness-codecs.conf`** -- negativo17 fedora-multimedia:
```
ffmpeg            ffmpegthumbnailer
gstreamer1-plugins-bad-free         gstreamer1-plugins-bad-free-libs
gstreamer1-plugins-base             gstreamer1-plugins-good
lame              lame-libs         libavcodec        libjxl
```

### New repos/ files

- `mecattaf-harnessRPM.repo`
- `tailscale.repo`
- `antigravity.repo`
- `google-cloud-cli.repo`
- `fedora-multimedia.repo` (negativo17)

### Modified greetd config

`mkosi.extra/etc/greetd/config.toml`:
```toml
[general]
service = "greetd-spawn"

[terminal]
vt = 1

[default_session]
command = "niri-session"
user = "tom"
```
(Zirconium had: `command = "dms-greeter --command niri"`, `user = "greeter"`)

### New mkosi.extra/ overlay files

**Networking/NAS/router:**
- `etc/NetworkManager/system-connections/router-link.nmconnection` -- static 10.0.0.1/24 on eth0
- `etc/firewalld/zones/external.xml` -- NAT masquerade for wlan0
- `etc/firewalld/zones/internal.xml` -- trusted LAN for eth0
- `etc/sysctl.d/99-router.conf` -- net.ipv4.ip_forward=1

**System config:**
- `etc/polkit-1/rules.d/10-udisks2.rules` -- wheel group mount/unlock without password
- `etc/systemd/resolved.conf.d/99-harness.conf` -- DNSSEC/DoT/cache config
- `etc/xdg/xdg-terminals.list` -- `kitty.desktop` (Zirconium: `footclient.desktop`)
- `etc/containers/policy.json` -- ghcr.io/mecattaf version
- `etc/containers/registries.d/harness.yaml` -- harness sigstore config

**Systemd units:**
- `usr/lib/systemd/system/enable-linger.service` -- enable lingering for UID 1000
- `usr/lib/systemd/system/mnt-nas.mount` -- //10.0.0.2/share CIFS mount
- `usr/lib/systemd/system/mnt-nas.automount` -- on-demand NAS mount
- `usr/lib/systemd/system/rechunker-group-fix.service`

**Executables:**
- `usr/bin/hjust` -- harness just wrapper (replaces zjust)
- `usr/bin/rechunker-group-fix` -- rechunker permissions fix
- `usr/libexec/enable-linger` -- linger enable script

**Harness data:**
- `usr/share/harness/just/00-start.just` -- harness just recipes
- `usr/share/pki/containers/harness.pub` -- container signing key

### Renamed overlay files

| Zirconium | Harness |
|---|---|
| `etc/profile.d/zirconium-font-settings.sh` | `harness-font-settings.sh` |
| `etc/profile.d/zirconium-qt-override.sh` | `harness-qt-override.sh` |
| `usr/lib/systemd/system-preset/01-zirconium.preset` | `01-harness.preset` |
| `usr/lib/systemd/user-preset/01-zirconium.preset` | `01-harness.preset` |

### System preset: 01-harness.preset

```
enable auditd.service
enable bootc-fetch-apply-updates.timer
enable brew-setup.service
enable cockpit.socket                    # NEW (harness)
enable enable-linger.service             # NEW (harness)
enable firewalld.service
enable flatpak-add-flathub-repos.service
enable greetd.service
enable mnt-nas.automount                 # NEW (harness)
enable systemd-resolved.service
enable systemd-timesyncd.service
enable tailscaled.service
enable uupd.timer
```

Removed vs Zirconium: `flatpak-preinstall.service`

### User preset: 01-harness.preset

```
enable chezmoi-init.service
enable chezmoi-update.timer
enable fcitx5.service
enable gnome-keyring-daemon.service
enable gnome-keyring-daemon.socket       # KEPT from Zirconium
enable gcr-ssh-agent.service             # KEPT from Zirconium
enable gcr-ssh-agent.socket
enable iio-niri.service
enable shpool.socket                     # NEW (harness)
enable udiskie.service
```

Removed vs Zirconium: `dms.service`, `foot-server.service`, `foot-server.socket`

### Modified chezmoi-init.service

Points to `/usr/share/harness/dotfiles` (not `/usr/share/zirconium/zdots`)

### mkosi.prepare.chroot additions

- Font pipeline downloads: `bash "$SRCDIR/build_files/fonts/install-fonts.sh"` (needs network access)

### mkosi.postinst.chroot additions

- Font cache rebuild (fonts already downloaded in prepare phase)
- Flatpak pipeline: `bash "$SRCDIR/build_files/flatpak/install-flatpaks.sh"`
- NAS directory: `install -d /mnt/nas`
- Kargs: create `/usr/lib/bootc/kargs.d/harness.toml`:
  ```toml
  kargs = ["amd_iommu=off", "ttm.pages_limit=33554432", "ttm.page_pool_size=33554432"]
  ```
- hjust completions (bash, zsh, fish)
- Branding: NAME="Harness", hostname="harness", HOME_URL="https://github.com/mecattaf/harness"
- stat check for `harness.pub` (instead of zirconium.pub)

### Modified base profile

`base/mkosi.conf.d/base-x86-64.conf`:
- Add: `libva`, `libva-utils`
- Remove: `virtualbox-guest-additions`

### ExtraTrees changes in harness-desktop.conf

```ini
ExtraTrees=
    cosign.pub:/usr/share/pki/containers/harness.pub
```
(Removed: zirconium.pub, assets/wallpapers, assets/logos)

---

## D. Gaps and risks

| # | Issue | Resolution |
|---|---|---|
| 1 | Package groups (`@multimedia`) may not work in mkosi | Enumerate individual packages explicitly |
| 2 | Wildcard removal (`sssd*`) may behave differently | Test in local build; enumerate if needed |
| 3 | Font pipeline needs network at build time | Move downloads to `mkosi.prepare.chroot` (has network) |
| 4 | Dotfiles need network for git clone | Added as git submodule instead |
| 5 | Negativo17 repo may conflict with Fedora repos | Set `priority=90` in repo file, test resolution |
| 6 | Google Cloud CLI repo format (Artifact Registry) | Test mkosi resolution; fallback to postinst curl/tar |
| 7 | Containerfile layer caching lost | mkosi `Incremental=yes` + `CacheDirectory` provide equivalent |
| 8 | kargs.json format -> TOML | One-time conversion to `/usr/lib/bootc/kargs.d/harness.toml` |
| 9 | Flatpak install at build time | Use first-boot service approach (same as Zirconium) |
| 10 | matugen was from zirconium/packages COPR (now gone) | Dropped -- no longer needed |

---

## E. Summary of naming changes

| Zirconium | Harness | Reason |
|---|---|---|
| `theme.conf` | `harness-desktop.conf` | Cleaner, descriptive |
| `avengemedia-danklinux.conf` | (deleted) | DMS not used |
| (none) | `harness-copr.conf` | mecattaf/harnessRPM packages |
| (none) | `harness-devtools.conf` | Dev/AI packages |
| (none) | `harness-extra-repos.conf` | Custom repos |
| (none) | `harness-codecs.conf` | Multimedia codecs |
| `01-zirconium.preset` | `01-harness.preset` | Branding |
| `zjust` / `zfetch` / `zmotd` | `hjust` (only) | Branding; zfetch/zmotd dropped |
| `zirconium-font-settings.sh` | `harness-font-settings.sh` | Branding |
| `zirconium-qt-override.sh` | `harness-qt-override.sh` | Branding |
