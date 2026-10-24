# Changelog

All notable Palorder iSH changes are recorded here. Version tags are release intent; the live commit registry is available with `palorder-history`.

## [0.5.0]
- Add a Palorder package manager workflow with package search, install/remove, installed package listing and package details.
- Add configurable default shell, with Bash as the default.
- Add phone and network diagnostics without assuming `ip` is installed.
- Add best-effort `/dev/palorder` symlinks and a bounded random-data helper.
- Add upstream commit registry and release-history commands.
- Expand Lua UI dialogs and window helpers.
- Improve mobile-sized dialog dimensions and terminal startup behavior.

## [0.4.0]
- Install and verify Lua 5.4 and dialog during setup.
- Install Bash, core utilities and Git; attempt optional developer tools.
- Add apt/apt-get and pacman compatibility wrappers that translate common commands to apk.

## [0.3.0]
- Add Lua 5.4 app host and permission-mediated app storage.
- Add version checker and developer toolchain UI.
