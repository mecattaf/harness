#!/usr/bin/env bash

set -xeuo pipefail

HOME_URL="https://github.com/mecattaf/harness"
echo "harness" | tee "/etc/hostname"

# OS Release File
sed -i -f - /usr/lib/os-release <<EOF
s|^NAME=.*|NAME="Harness"|
s|^PRETTY_NAME=.*|PRETTY_NAME="Harness"|
/^VERSION_CODENAME=/d
s|^VARIANT_ID=.*|VARIANT_ID=""|
s|^HOME_URL=.*|HOME_URL="${HOME_URL}"|
s|^BUG_REPORT_URL=.*|BUG_REPORT_URL="${HOME_URL}/issues"|
s|^SUPPORT_URL=.*|SUPPORT_URL="${HOME_URL}"|
s|^CPE_NAME=".*"|CPE_NAME="cpe:/o:mecattaf:harness"|
s|^DOCUMENTATION_URL=.*|DOCUMENTATION_URL="${HOME_URL}"|
s|^DEFAULT_HOSTNAME=.*|DEFAULT_HOSTNAME="harness"|

/^REDHAT_BUGZILLA_PRODUCT=/d
/^REDHAT_BUGZILLA_PRODUCT_VERSION=/d
/^REDHAT_SUPPORT_PRODUCT=/d
/^REDHAT_SUPPORT_PRODUCT_VERSION=/d
EOF

# Disable Fedora flatpak remote, enable flathub
rm -rf /usr/lib/systemd/system/flatpak-add-fedora-repos.service
systemctl enable flatpak-add-flathub-repos.service

# Remove chsh footgun
rm -rf /usr/bin/chsh

# Enable rechunker group fix
systemctl enable rechunker-group-fix.service

# Verify critical files exist
stat /usr/bin/uupd
stat /usr/lib/systemd/system/uupd.service
stat /usr/lib/systemd/system/uupd.timer

# Symlinks
rm -rfv /opt /usr/local
ln -s /var/usrlocal /usr/local
ln -s /var/opt /opt
