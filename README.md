# Palorder iSH

A terminal-first, dialog-powered Alpine environment for [iSH on iOS](https://github.com/ish-app/ish). It adds a welcome screen, setup assistant, package shortcuts, utilities, task runner, and updater without pretending iSH is a full graphical Linux desktop.

## Install

Open iSH and run:

```sh
curl -fsSL https://raw.githubusercontent.com/PalorderSoftWorksOfficial/Palorder-ish/main/install.sh | sh
```

The installer downloads runtime files only into `/root/bin`. It does not install `AGENTS.md`, contribution guides, tests, or GitHub workflow files. Review [install.sh](install.sh) before running it.

Launch the menu with `palorder` or use `palorder-setup`, `palorder-packages`, `palorder-utilities`, and `palorder-update`.

## Requirements

- iSH on iPhone or iPad
- Alpine userland with working `apk`
- Network access
- `dialog` for interactive menus; the installer attempts to install it

iSH is an emulated, app-sandboxed environment, not a full Linux virtual machine. Package compatibility, performance, networking, and background execution differ from desktop Alpine. This project does not install XFCE or provide a graphical desktop.

## Features

- Text-based welcome and main menu
- Setup checks and optional developer-tool installation
- Package search, install, remove, and update shortcuts
- System, storage, and network diagnostics
- Confirm-before-run command runner
- Runtime self-update
- Uninstaller that preserves settings unless you remove them manually

## Paths

- Runtime scripts: `/root/bin`
- Settings: `/root/.config/palorder/settings`
- Display name: `/root/.config/palorder/identity`
- Version marker: `/root/.config/palorder/version`

The installer backs up existing runtime scripts and preserves settings. Updating fetches scripts from `main`; pin a reviewed commit for reproducible installs.

## Security

Do not run commands from untrusted issues or pull requests. Never store passwords, API tokens, or private keys in settings. The task runner asks for confirmation before executing a command. Software is provided without warranty.

See [AGENTS.md](AGENTS.md), [CONTRIBUTING.md](CONTRIBUTING.md), and [SECURITY.md](SECURITY.md). These development files are not part of the runtime payload.

## License

MIT. See [LICENSE](LICENSE).
