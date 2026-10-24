# Agent instructions

## Scope
Palorder iSH is a POSIX-shell UI and helper suite for iSH's Alpine userland. It is not a distribution, graphical desktop, VM, or replacement for iSH.

## Compatibility
- Runtime scripts use POSIX /bin/sh and Alpine BusyBox ash.
- Avoid GNU-only utilities and unavailable kernel features.
- Keep the interface terminal-first; do not claim to provide a graphical desktop.
- Do not assume all Alpine packages work in iSH.

## Installer and customization contract
- One-line install: curl -fsSL https://raw.githubusercontent.com/PalorderSoftWorksOfficial/Palorder-ish/main/install.sh | sh
- Default reinstall must preserve existing runtime files and all user preferences.
- Explicit --update may replace managed files only after staging downloads and backing up current files.
- Keep theme, boot-banner, and display-name preferences under /root/.config/palorder.
- Runtime payload is an explicit allowlist. Never install AGENTS.md, README, tests, contribution docs, security policy, or CI files into iSH.
- Fail on download errors and empty files before replacing installed files.

## Safety
- Confirm destructive actions and arbitrary command execution.
- Do not add credential collection, telemetry, remote command execution, or secrets to settings.
- Do not source settings as shell code; parse known keys.
- Keep configuration under /root/.config/palorder.

## CI
- Jenkinsfile is the CI entry point.
- Do not add GitHub Actions workflows.
- Validate shell syntax and installer payload allowlist; run ShellCheck when available.

## Validation
- Run sh -n on all shell scripts.
- Verify installer/update failures do not replace existing files.
- Check all raw GitHub URLs and paths before changing them.
