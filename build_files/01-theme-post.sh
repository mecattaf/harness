#!/bin/bash

set -xeuo pipefail

install -d /usr/share/harness/

# Remove fcitx5 desktop launchers
rm -f /usr/share/applications/fcitx5-wayland-launcher.desktop
rm -f /usr/share/applications/org.fcitx.Fcitx5*.desktop

# Modify greetd PAM: add gnome-keyring support
sed --sandbox -i -e '/gnome_keyring.so/ s/-auth/auth/ ; /gnome_keyring.so/ s/-session/session/' /etc/pam.d/greetd

# Enable system services
systemctl preset greetd.service
systemctl preset tailscaled.service

# Enable user services globally
systemctl preset --global chezmoi-init.service
systemctl preset --global chezmoi-update.timer
systemctl preset --global fcitx5.service
systemctl preset --global gnome-keyring-daemon.service
systemctl preset --global gcr-ssh-agent.socket
systemctl preset --global iio-niri.service
systemctl preset --global udiskie.service

# Rebuild font cache
fc-cache --force --really-force --system-only --verbose

# Generate hjust shell completions
install -d /usr/share/bash-completion/completions /usr/share/zsh/site-functions /usr/share/fish/vendor_completions.d/
just --completions bash | sed -E 's/([\(_" ])just/\1hjust/g' > /usr/share/bash-completion/completions/hjust
just --completions zsh | sed -E 's/([\(_" ])just/\1hjust/g' > /usr/share/zsh/site-functions/_hjust
just --completions fish | sed -E 's/([\(_" ])just/\1hjust/g' > /usr/share/fish/vendor_completions.d/hjust.fish

# Run bb-flatpak installer
bash /ctx/build_files/flatpak/install-flatpaks.sh
