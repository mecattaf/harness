# Deviation from zirconium ec2a120

Zirconium commit [ec2a120](https://github.com/zirconium-dev/zirconium/commit/ec2a120) (2026-03-27, *"feat: move every override from `/etc` to `/usr/share/factory` and use tmpfiles"*) migrated all baked-in `/etc` overrides to `/usr/share/factory/etc/` plus a `99-zirconium-factory.conf` tmpfiles.d rule that re-creates them under `/etc` at first boot. The goal was stronger immutability — everything in `/usr` is read-only OSTree content, and the boot-time tmpfiles drop seeds `/etc` so daemons that only read from `/etc` still find their defaults.

**Harness does not follow this migration.**

We keep our overrides under `mkosi.extra/etc/` because harness's `/etc` tree has runtime configurations whose daemons do NOT standardly load from `/usr/lib/` mirrors — most notably `NetworkManager/dnsmasq-shared.d/`. A partial migration (just the greetd/PAM/profile.d/containers subset that zirconium moved) would add file-layout surface area without immutability gains for the parts that matter most for harness's networking story. We may revisit this once those daemons gain consistent `/usr` drop-in support.

Companion commit [43f7284](https://github.com/zirconium-dev/zirconium/commit/43f7284) (path fix for `flatpak-add-flathub-repos.service`) is also skipped — harness's service file already references `/usr/share/flatpak/remotes.d/...`, unaffected by ec2a120.
