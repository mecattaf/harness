
  A. Structural / breaking changes (biggest blast radius)

  - ec2a120 feat: move every override from /etc to /usr/share/factory and use tmpfiles — moves greetd config,
  profile.d scripts, containers policy, taidan.toml, etc. into mkosi.extra/usr/share/factory/etc/... + adds
  99-zirconium-factory.conf. Foundational; many later fixes depend on it.
  > approved. this one does require additional thinkng because you must identify what are my own harness-specific changes that would be affected by this transition, but the instinct to move to usr share factory is acceptable
  - d18316e chore(base): move base profile to base-desktop (+ e2f5d7e fix: base-desktop profile not being
  recognized)
  > acceptable, roll into that
  - eae9e61 feat(sysupdate): first functional sysupdate image (#175) — adds a whole new
  mkosi.profiles/sysupdate/ profile (repart, sysupdate, uki-profiles, finalize, postinst). Renames
  reusable-build.yaml → reusable-build-bootc.yaml. Big addition.
  > approved
  - 478b442 chore(just): refactor all zjusts, remove bluefin-common submodule — rewrites 00-start.just (242
  lines), adds luks-tpm2-autounlock script, drops subprojects/bluefin-common, removes .editorconfig +
  artifacthub-repo.yml.
  > i do not use zjust! but remocing bluefin-common submodule is accepted, and so is removing .editorconfig and articacthubrepo-buld.yaml (if it exists)
  - 38ef3eb fix(dms-greeter): set DMS_PRIVESC + enable PAM auth (depends on the /etc → factory move)
  > i do not use dms-greeter; but you must check how i do my automated greeting (no first time password on my devices, this needs to stick), so if PAM auth needs to reflect taht also, do it
  - 43f7284 chore: fix flathub repos service (path fix after /etc → factory move)
  > fix that if i am afected. i do use flatpaks on my computer.
  - 1ce5a8d alias run67 to run0 (zfunny.sh)
  > most likely skip because i do not use zfunny (and neither do i use any z-something scripts)

  B. Build / mkosi tuning

  - 7963d2f fix: default output dir = mkosi.output at repo root
  > approved, bring that over and verify downstream consequences of that
  - f31632d chore: move bootc install configs out of shared profile
  > approved; unless you find that i have one single profile (not "shared") - be critical with that one
  - b3c897b chore: don't use recommended packages + typos
  > likely skip, check if any value here
  - b76fd0a fix(justfile): use mkosi.output, btrfs as default VM fs
  > i think this is already being done, but check out the changes this brings just in case
  - b02af1b fix: always install recommended packages
  > i think this is already being done, but check out the changes this brings just in case
  - f2be3cb feat: add qt5-qtimageformats + rearrange theme.conf using recommends=true (big diff)
  > check if this is something that affects me, and if it does then approved
  - 170b505 chore: remove a workaround for bootc install
  > approved, but check critically
  - b6306cc chore: rechunk to 127 layers, dedicate one for brew
  > approved, i want to have brew on my system

  C. Package add/remove (mostly mkosi.conf.d/theme.conf one-liners)

  - 41bcf85 feat: add btop
  > approved
  - 28143ee feat: add nmtui, nm-connection-editor, lshw (#231)
  > approved
  - 5b308e9 chore(foot): remove foot server desktop entry (#239)
  > approved, i m pretty sure i removed foot terminal anyway but check just to make sure
  - 44f4d0e fix: re-add distrobox (#240) — note harness already has ae1425d feat: add toolbox and distrobox
  explicitly, so probably skip
  > instal distrobox the same way as them (most likely nothing to do here)
  - 0534dbd chore: remove lchsh
  > remove lchsh unless i already removed it myself
  - c9ce7c3 chore(fastfetch): remove appimages from package list + glorpfetch shell fix
  > approved: no apimages (i don t use it); pretty sure i don't use "glorpfetch" myself so should be nothing to do there. just good ot follow zircinium cleanup methodology
  - 9129f3f chore(pipewire): remove explicit raop install
  > approved

  D. Screenshot / desktop tooling

  - e4c469d feat: add satty screenshot manager (+ 05a51f3 fix: warning on service)
  > approved! a cool tool. make sure that we place it in the right location (terra if terra, etc.)
  - 586a2ad feat: add zorc OCR screenshot script (mkosi.extra/usr/bin/zocr)
  > i dug a little into this. "zorc" was a typo, he meant "zocr". this involves adding the `tesseract` package to the image, and adding a script called "zocr". i loved this script, bring it over but rename the script "ocr"; ad the line "inspired by zirconium" to give credits where it's due
  > for the satty AND ocr functionality these should be specifically mentioned in the commit description, so that i remind myself to benefit from and implement this functionality in the dot config side of things
  - 6520b85 fix: add openrgb udev rules (#227)
  > skip, i do not care about openrgb

  E. NVIDIA repo migration

  - f4d6440 fix(nvidia): use negativo17-nvidia repo — adds repos/negativo-17-nvidia.repo, rewrites nvidia
  profile
  > NO nvidia whatsoever. i do not use nvidia.
  - 22f2dc5 use official nvidia-container-toolkit repo — adds repos/nvidia-container-toolkit.repo, removes
  repos/terra-nvidia.repo
  > skip. no nvidia whatsoever.

  F. System services & defaults

  - 49f56df fix(selinux): semanage reads from /etc/selinux (#228)
  > approved
  - c6b51ef fix(default): dms greeter cache directory
  > i do not use dms greeter, so skip unless you think this is also relevant to the way i am logging in myself
  - d7561ed feat(ntpd): use ntpd-rs instead of systemd-timesyncd
  > approved
  - a0bf266 fix(iio-niri): fix 2.0 update flags
  > not sure about this one, check if i use io-niri myself (possible i already removed it in which case remove that one as well); if it turns out i did include it in harness then follow the same
  - 657bb5f chore: do not use bootc-fetch-apply-updates (uupd handles it)
  > approved
  - dd9f278 Disable sshd by default (#270)
  > approved: pretty sure i do not use sshd in `harness` either, this is good instinct
  - be23267 fix(just): flip actions for toggle-updates
  > skip, pretty sure i do not use "just" or "zjust" or whatever

  G. uupd source migration

  - 29ce365 feat(uupd): install uupd from terra instead of ublue copr (#238) — drops
  repos/ublue-os-packages.repo and mkosi.conf.d/ublue-os-packages.conf. (NOTE: this is the change that
  accidentally dropped distrobox → 44f4d0e fixed it; both should land together or you skip both.)
  > we install distrobox in a more sane way i believe. and sure, installing uupd from terra not from ublue copr is totaly fine. make sure that dropping ublue-os-packages.repo won t damage me (pretty sure it won't). aproved but be careful with that one

  H. CI / workflows

  - dae95b9 fix(iso): build bootc-image-builder ISOs again
  > approved
  - 1e1c6d6 ci: fix non-base image builds (#229)
  > unsure, i am pretty sure i only have a base image build..
  - b816af1 ci: add fedora version + commit-based tagging per image
  > approved. good practice
  - 5c84307 chore(ci): use checkout for repository information during tagging
  > approved. good practice
  - 25a2179 fix(ci): use full commit sha
  > approved. good practice
  - 1ef525d fix(ci): tag releases properly on rolling image tags like rawhide
  > approved. good practice
  - de1b75e fix: add checkout for release version
  > approved. good practice
  - 2f98da8 chore(ci): exclude full path of resulting iso
  > approved. good practice
  - 35b0ad7 feat(ci): use zstd for pushing
  > approved. good practice
  - dabdf81 chore(ci): for-loop for pushing the image
  > approved. good practice
  - dd90145 fix(ci): run apt update before installing build deps
  > approved. good practice
  - 1558ab2 chore(mkosi): utilize artifacthub date format (mkosi.bump)
  > approved. good practice
  - e6d1cfa chore(iso): enable localization section (iso.toml, iso-nvidia.toml)
  > unsure, pretty sure i do not need localization especially because we do not include nvidia whatsoever in harness

  I. Zirconium-specific (probably skip / translate)

  - 6beb455 change codename to "pibble" (mkosi.postinst.chroot — branding only, you'd want your own)
  > skip

  J. Renovate / dep bumps (skip unless you want bulk catch-up)
  6c5fe90, f2bcd43, 61f8a76, 015cd4c, 30e6040, 7e8e138, 1169c62, 3bc4c6d, 87d1e73, 06ec674, b09425f, 1310938,
  568e25b, 875d674 — actions/cache, upload-artifact, cosign-installer, setup-just, ublue-brew submodule, zdots
   submodule, bluefin-common submodule.
    > good instinct on that one: but we do not have zdots so skip that one. for the rest, i think bumping is indeed the right move, s we bulk catch-up

