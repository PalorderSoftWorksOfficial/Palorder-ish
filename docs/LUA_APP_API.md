# Palorder Lua application API

Palorder's Lua 5.4 runtime is for small interactive applications in iSH. It is not a virtual machine and does not create Android-style OS-user isolation.

## Install and create an app

    apk add lua5.4 dialog
    palorder-app create hello
    palorder-app run hello

## App layout

Apps live in ~/.local/share/palorder/apps/APP_ID/ and contain a manifest and main.lua.

Example manifest:

    name=Counter
    version=1.0.0
    permissions=storage

App IDs match ^[a-z][a-z0-9_-]{0,47}$. Source files are limited to 256 KiB and stored values to 64 KiB.

## API reference

- api.app: app id, name, and version metadata.
- api.version: runtime API version.
- api.ui.message(title, body): display a message dialog.
- api.ui.input(title, prompt, initial?): get text; returns nil on cancel.
- api.ui.confirm(title, prompt): return true if accepted.
- api.ui.menu(title, prompt, entries): entries are { id = "settings", label = "Settings" }; returns the selected id or nil.
- api.storage.get(key), set(key, value), delete(key): require the storage permission in the manifest. Keys are limited to letters, digits, underscore, dot, and hyphen. Data is app-scoped but not encrypted.
- api.system.info(): returns a short OS/kernel string.

## Security model

The app environment omits os, io, debug, package, require, loadfile, dofile, and dynamic code loading. It provides no public arbitrary-shell API. Storage uses a per-app directory and requires a declared capability. UI calls are mediated by the runtime host.

This is a language-level restriction, not a hardened hostile-code boundary. The host process still has the privileges of the Palorder/iSH account. There is no per-app UID or SELinux policy here; an interpreter escape or host bug could access that account's files. Lua infinite loops can consume CPU because this implementation does not enforce a robust instruction quota. Do not run untrusted apps or store secrets in app storage. Android-grade isolation would require OS-enforced process and filesystem restrictions that this iSH environment does not currently provide.
