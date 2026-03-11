#!/bin/bash

set -xeuo pipefail

dnf -y remove \
  firefox \
  firefox-langpacks \
  virtualbox-guest-additions \
  nvtop \
  sway \
  yggdrasil \
  adcli \
  libdnf-plugin-subscription-manager \
  python3-subscription-manager-rhsm \
  subscription-manager \
  subscription-manager-rhsm-certificates \
  console-login-helper-messages \
  chrony \
  sssd* \
  qemu-user-static*
