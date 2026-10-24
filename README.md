# Palorder iSH

A terminal-first, dialog-powered Alpine environment for [iSH on iOS](https://github.com/ish-app/ish). It provides a GRUB-inspired keyboard-controlled boot menu, splash screen, setup wizard, Control Center, terminal session, Lua application runtime, developer tools, package shortcuts, diagnostics and updater. It is not a full graphical Linux desktop.

## Install

Open iSH and run:

    curl -fsSL https://raw.githubusercontent.com/PalorderSoftWorksOfficial/Palorder-ish/main/install.sh | sh

The installer prints a numbered bootstrap sequence, refreshes Alpine indexes, installs and verifies Lua 5.4, Bash, dialog, core command-line utilities, and Git before launching the UI. It then attempts to install optional archive tools, networking diagnostics, Python/pip, editors, SSH, and build tools, warning if a repository cannot provide an optional group. If required runtime setup fails, it stops with an error instead of opening a partially installed desktop. The Application Center also attempts to repair a missing Lua runtime. Use --safe to install missing files only.

## Updates

    check-update
    check-update --files
    palorder-update

check-update compares version metadata by default; --files compares each managed script without installing or executing downloaded files. palorder-update stages the full runtime, backs up existing files, then installs the staged versions. Review backups if you have local script modifications.

## Lua applications

The Lua 5.4 runtime provides a small capability-oriented API for interactive apps.

    palorder-app --help
    palorder-app create hello
    palorder-app run hello
    palorder-app list
    palorder-app info hello

Apps are stored in ~/.local/share/palorder/apps/APP_ID/ and app data in ~/.local/share/palorder/data/APP_ID/. See docs/LUA_APP_API.md for the API and security model. The sandbox removes direct os/io/debug/package access and has no public arbitrary-shell API. It is not an Android-grade security boundary: apps share the same iSH/Alpine account, there is no per-app UID/SELinux isolation, and CPU quotas are not enforced. Do not run untrusted apps or store secrets in app data.

## Package-manager compatibility

The commands `apt`, `apt-get`, and `pacman` are compatibility wrappers that translate common operations to Alpine `apk`; they do not install Debian or Arch packages or create those distributions' package databases.

```sh
apt update
apt install bash git python3
apt remove PACKAGE
apt search lua
apt show lua5.4
pacman -Syu
pacman -S bash git
pacman -R PACKAGE
pacman -Ss lua
```

Package names must exist in the Alpine repositories. Unsupported command options are not emulated. Use `apk --help` for native Alpine behavior.

## Developer tools

Open Control Center → Install developer toolchain to install Lua 5.4, Git, Python/pip, build tools, headers, curl, jq, nano, vim, tmux, OpenSSH client and CA certificates. Package availability depends on the Alpine repositories enabled in your iSH environment.

## Customize

Run palorder, then open Appearance and preferences.

- Theme: Midnight/Cyan, Violet, Amber, Emerald, or Monochrome
- Boot banner: show or hide the ASCII banner
- Display name: change the startup greeting
- Reset preferences: reset only theme and banner

Preferences are in /root/.config/palorder/settings; display name is in /root/.config/palorder/identity. Updates preserve these files.

## Requirements and limitations

- iSH on iPhone or iPad
- Alpine userland with working apk
- Network access
- dialog and Lua 5.4 (the installer attempts to install both)

iSH is an emulated, app-sandboxed environment, not a full Linux VM. Package compatibility, performance, networking, and background execution differ from desktop Alpine. Palorder does not install XFCE or claim to provide a graphical desktop.

## Paths

- Runtime scripts: /root/bin
- Preferences: /root/.config/palorder
- Lua apps: ~/.local/share/palorder/apps
- App data: ~/.local/share/palorder/data
- Backups: /root/.config/palorder/backups

## Jenkins CI

The repository uses Jenkinsfile, not GitHub Actions. Configure a Pipeline job using Pipeline script from SCM, Git repository https://github.com/PalorderSoftWorksOfficial/Palorder-ish.git, branch */main and Script Path Jenkinsfile. CI checks shell syntax, optionally checks Lua syntax and ShellCheck, and validates the installer allowlist.

## Security

Never store passwords, API tokens or private keys in settings or app storage. Do not run code from untrusted issues or pull requests. The command runner executes commands as the current iSH user after confirmation. Software is provided without warranty.

See AGENTS.md, CONTRIBUTING.md, SECURITY.md and docs/LUA_APP_API.md.

## License

MIT. See LICENSE.
