#!/bin/sh
set -eu
OWNER="PalorderSoftWorksOfficial"
REPO="Palorder-ish"
BRANCH="main"
BASE="https://raw.githubusercontent.com/$OWNER/$REPO/$BRANCH"
BIN_DIR="/root/bin"
CONFIG_DIR="/root/.config/palorder"
STAMP=$(date +%Y%m%d-%H%M%S 2>/dev/null || echo install)
BACKUP_DIR="$CONFIG_DIR/backups/$STAMP"
FILES="palorder palorder-boot palorder-ui palorder-setup palorder-settings palorder-packages palorder-update palorder-run-task palorder-utilities palorder-terminal palorder-control palorder-lua-host palorder-app check-update palorder-version"
say() { printf '%s\n' "Palorder iSH: $*"; }
fail() { say "ERROR: $*" >&2; exit 1; }
MODE=update
case "${1:-}" in
  "") ;;
  --update|--force) MODE=update ;;
  --safe) MODE=safe ;;
  --help|-h) printf '%s\n' "Usage: install.sh [--safe|--update|--force]" "Default: back up and update managed runtime files." "--safe: install missing files only and preserve existing runtime scripts."; exit 0 ;;
  *) fail "Unknown option: $1. Use --help." ;;
esac
command -v curl >/dev/null 2>&1 || fail "curl is required. Install it with: apk add curl"
command -v apk >/dev/null 2>&1 || fail "apk was not found. This installer requires Alpine/iSH."
mkdir -p "$BIN_DIR" "$CONFIG_DIR"
say "Ensuring dialog and Lua 5.4 are installed..."
apk add --no-cache dialog lua5.4 || fail "Could not install dialog/Lua 5.4. Check /etc/apk/repositories and network."
if ! command -v dialog >/dev/null 2>&1; then fail "dialog package installed but the dialog command is missing."; fi
LUA_BIN=""
for candidate in lua5.4 lua54 lua; do
  if command -v "$candidate" >/dev/null 2>&1; then
    version=$("$candidate" -v 2>&1 || :)
    case "$version" in *"5.4"*) LUA_BIN=$candidate; break ;; esac
  fi
done
[ -n "$LUA_BIN" ] || fail "Lua 5.4 is still unavailable after apk installation. Try: apk update && apk search lua && apk add lua5.4"
say "Lua interpreter verified: $LUA_BIN"
STAGE="$CONFIG_DIR/install-stage.$$"; mkdir -p "$STAGE"
cleanup() { rm -rf "$STAGE"; }; trap cleanup EXIT HUP INT TERM
for file in $FILES; do
  if [ "$MODE" = safe ] && [ -e "$BIN_DIR/$file" ]; then say "Keeping existing $file (safe reinstall)."; continue; fi
  say "Downloading $file"
  curl -fLsS --connect-timeout 15 --max-time 120 "$BASE/runtime/$file" -o "$STAGE/$file" || fail "Download failed for $file. Existing runtime files were not replaced."
  [ -s "$STAGE/$file" ] || fail "Downloaded file is empty: $file"
  chmod 755 "$STAGE/$file"
done
[ "$MODE" != update ] || mkdir -p "$BACKUP_DIR"
for file in $FILES; do
  [ -f "$STAGE/$file" ] || continue
  if [ "$MODE" = update ] && [ -f "$BIN_DIR/$file" ]; then cp -p "$BIN_DIR/$file" "$BACKUP_DIR/$file"; fi
  mv "$STAGE/$file" "$BIN_DIR/$file"
done
[ -f "$CONFIG_DIR/settings" ] || printf '%s\n' 'THEME=midnight' 'SHOW_BANNER=1' > "$CONFIG_DIR/settings"
[ -f "$CONFIG_DIR/identity" ] || printf '%s\n' "Palorder User" > "$CONFIG_DIR/identity"
cp "$BIN_DIR/palorder-version" "$CONFIG_DIR/version"
PROFILE_LINE='export PATH="/root/bin:$PATH"'
if [ -f /root/.profile ]; then grep -Fq "$PROFILE_LINE" /root/.profile || printf '%s\n' "$PROFILE_LINE" >> /root/.profile; else printf '%s\n' "$PROFILE_LINE" > /root/.profile; fi
PROFILE=/root/.profile
if ! grep -Fq '# BEGIN PALORDER AUTO START' "$PROFILE"; then
  cat >> "$PROFILE" <<'PALORDER_PROFILE'

# BEGIN PALORDER AUTO START
case "$-" in
  *i*)
    if [ "${PALORDER_NO_AUTO_START:-0}" != 1 ] && [ -x /root/bin/palorder ]; then exec /root/bin/palorder; fi
    ;;
esac
# END PALORDER AUTO START
PALORDER_PROFILE
fi
say "Installation complete. Preferences and display name were preserved."
if [ "$MODE" = safe ]; then say "Safe mode kept existing scripts."; else say "Updated managed scripts; backups are in $BACKUP_DIR"; fi
say "Automatic startup registered in /root/.profile."
say "Disable automatic startup by setting PALORDER_NO_AUTO_START=1 before the hook."
say "Commands: palorder-app --help | check-update --help"
say "Launch with: /root/bin/palorder"
"$BIN_DIR/palorder"
