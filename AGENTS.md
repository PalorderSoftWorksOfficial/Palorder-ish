# Agent instructions

## Scope
Palorder iSH is a POSIX-shell UI and helper suite for iSH's Alpine userland. It is not a distribution, graphical desktop, VM, or replacement for iSH.

## Compatibility
- Runtime scripts use POSIX /bin/sh and Alpine BusyBox ash.
- Do not assume GNU-specific utilities or unavailable kernel features.
- Keep the interface terminal-first; do not add XFCE or claim a desktop is provided.
- Do not assume all Alpine packages work in iSH.

## Installer contract
- One-line installer: curl -fsSL https://raw.githubusercontent.com/PalorderSoftWorksOfficial/Palorder-ish/main/install.sh | sh
- The installer payload is an explicit allowlist of files under runtime/.
- Never install AGENTS.md, README, tests, contribution docs, security policy, or workflows into iSH.
- Fail on download errors and empty files. Preserve user configuration and back up replaced runtime scripts.
- Avoid executing downloaded metadata.

## Safety
- Confirm destructive actions and arbitrary command execution.
- Do not add credential collection, telemetry, remote command execution, or secrets to settings.
- Keep configuration under /root/.config/palorder.

## Validation
- Run sh -n on changed shell scripts and ShellCheck when available.
- Verify installer failure paths and ensure development files are excluded from its payload.
- Check links and repository paths before changing them.
