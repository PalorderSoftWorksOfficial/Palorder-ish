# Palorder Lua application API

Palorder provides a Lua 5.4 runtime for interactive apps in iSH. It is not a virtual machine and does not create Android-style OS-user isolation.

## Install and create an app

    apk add lua5.4 dialog
    palorder-app create hello
    palorder-app run hello

The first launch of an app requesting storage asks the user for permission. Decisions are stored in /root/.config/palorder/permissions. Inspect with:

    palorder-app permissions hello
    palorder-app revoke hello storage

Revoking removes the saved decision; the next launch asks again.

## App layout

Apps live in ~/.local/share/palorder/apps/APP_ID/ and contain a manifest and main.lua.

Example manifest:

    name=Counter
    version=1.0.0
    permissions=storage

App IDs match ^[a-z][a-z0-9_-]{0,47}$. Source files are limited to 256 KiB and stored values to 64 KiB.

## API reference

- api.app: app id, name, and version metadata.
- api.version: runtime API version (currently 1.1).
- api.ui.message(title, body): display a message dialog.
- api.ui.input(title, prompt, initial?): get text; returns nil on cancel.
- api.ui.confirm(title, prompt): return true if accepted.
- api.ui.menu(title, prompt, entries): entries are { id = "settings", label = "Settings" }; returns the selected id or nil.
- api.ui.textbox(title, body): display a scrollable text viewer; returns false if cancelled.
- api.ui.password(title, prompt): display a masked password prompt; returns the entered string or nil on cancel. Apps are responsible for not logging or persisting secrets.
- api.ui.checklist(title, prompt, entries): entries are { id = "one", label = "First option", selected = true }; returns an array of selected IDs or nil on cancel.
- api.window: aliases for the dialog helpers above, for window-oriented app code.
- api.dialog: alias for api.ui.
- api.system.network_info(): returns a limited report about the iSH runtime and resolver configuration; it does not expose iOS Wi-Fi/Bluetooth controls.
- api.storage.get(key), set(key, value), delete(key): require both a manifest declaration and user-granted storage permission. Keys are limited to letters, digits, underscore, dot, and hyphen, excluding "." and "..". Data is app-scoped but not encrypted.
- api.system.info(): returns a short OS/kernel string.

## Security model and limits

The app environment omits os, io, debug, package, require, loadfile, dofile, and dynamic code loading. It provides no public arbitrary-shell API. The host mediates dialogs and storage. Each app has its own data directory; the storage capability is requested on first launch and can be revoked. Lua source is capped at 256 KiB, storage values at 64 KiB, and a debug instruction hook stops scripts after roughly one million VM instructions.

This is a language-level restriction, not a hardened hostile-code boundary. The host process still has the privileges of the Palorder/iSH account. There is no per-app UID or SELinux policy here; an interpreter escape or host bug could access that account's files. Instruction quotas do not limit time spent in native library calls. Do not run untrusted apps or store secrets in app storage. Android-grade isolation would require OS-enforced process and filesystem restrictions that this iSH environment does not currently provide.
