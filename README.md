# Palorder iSH

A terminal-first, dialog-powered Alpine environment for [iSH on iOS](https://github.com/ish-app/ish). It provides a welcome screen, setup assistant, package shortcuts, utilities, command runner, and updater. It is not a full graphical Linux desktop.

## Install

Open iSH and run:

```sh
curl -fsSL https://raw.githubusercontent.com/PalorderSoftWorksOfficial/Palorder-ish/main/install.sh | sh
```

The default installer is safe to rerun: it installs missing runtime files and leaves existing runtime scripts untouched. It preserves preferences and the display name. It downloads only an explicit list of files from `runtime/`, never development files.

### Update or repair managed scripts

To intentionally replace managed runtime scripts, download the installer and pass `--update`:

```sh
curl -fsSL https://raw.githubusercontent.com/PalorderSoftWorksOfficial/Palorder-ish/main/install.sh -o /tmp/palorder-install.sh
sh /tmp/palorder-install.sh --update
```

This backs up existing managed scripts before replacement. The in-app updater also backs up scripts first. If you modified scripts under `/root/bin`, review backups before updating.

## Customize

Run `palorder`, then open **Appearance and preferences**.

- **Theme:** Midnight/Cyan, Violet, Amber, Emerald, or Monochrome
- **Boot banner:** show or hide the ASCII banner
- **Display name:** change the startup greeting
- **Reset preferences:** reset only theme and banner; display name, packages, and scripts remain unchanged

Preferences live in `/root/.config/palorder/settings`; the display name is in `/root/.config/palorder/identity`. Installation and update preserve these files.

## Requirements

- iSH on iPhone or iPad
- Alpine userland with working `apk`
- Network access
- `dialog` for menus; the installer attempts to install it

iSH is an emulated, app-sandboxed environment, not a full Linux VM. Package compatibility, performance, networking, and background execution differ from desktop Alpine. This project does not install XFCE or claim to provide a graphical desktop.

## Features

- Terminal welcome screen and main menu
- Appearance and preferences menu
- Setup checks and optional developer tools
- Package search, install, remove, and upgrade shortcuts
- System, storage, and network diagnostics
- Confirm-before-run command runner
- Staged self-updater with backups
- Safe default reinstall

## Paths

- Runtime scripts: `/root/bin`
- Preferences: `/root/.config/palorder/settings`
- Display name: `/root/.config/palorder/identity`
- Backups: `/root/.config/palorder/backups`

## Jenkins CI

The repository uses `Jenkinsfile`, not GitHub Actions. In Jenkins, create a **Pipeline** job, select **Pipeline script from SCM**, choose **Git**, enter repository URL `https://github.com/PalorderSoftWorksOfficial/Palorder-ish.git`, set branch to `*/main`, and set **Script Path** to `Jenkinsfile`. Save and click **Build Now**. The pipeline checks shell syntax, validates the installer allowlist, and runs ShellCheck if installed on the Jenkins agent.

## Security

Do not run commands from untrusted issues or pull requests. Never store passwords, API tokens, or private keys in settings. The command runner asks for confirmation before execution. Software is provided without warranty.

See [AGENTS.md](AGENTS.md), [CONTRIBUTING.md](CONTRIBUTING.md), and [SECURITY.md](SECURITY.md). These development files are not part of the runtime payload.

## License

MIT. See [LICENSE](LICENSE).
