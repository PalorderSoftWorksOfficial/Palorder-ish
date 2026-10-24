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
FILES="palorder palorder-boot palorder-ui palorder-setup palorder-settings palorder-packages palorder-update palorder-run-task palorder-utilities palorder-terminal palorder-control"
say() { printf '%s\n' "Palorder iSH: $*"; }
fail() { say "ERROR: $*" >&2; exit 1; }
MODE=safe
case "${1:-}" in
  "") ;;
  --update|--force) MODE=update ;;
  --help|-h) printf '%s\n' "Usage: install.sh [--update|--force]" "Default: preserve existing runtime files." "--update: back up and replace managed runtime files."; exit 0 ;;
  *) fail "Unknown option: $1. Use --help." ;;
esac
command -v curl >/dev/null 2>&1 || fail "curl is required. Install it with: apk add curl"
command -v apk >/dev/null 2>&1 || fail "apk was not found. This installer requires Alpine/iSH."
mkdir -p "$BIN_DIR" "$CONFIG_DIR"
if ! command -v dialog >/dev/null 2>&1; then
  say "Installing dialog..."
  apk add --no-cache dialog || fail "Could not install dialog. Check network and /etc/apk/repositories."
fi
STAGE="$CONFIG_DIR/install-stage.$$"
mkdir -p "$STAGE"
cleanup() { rm -rf "$STAGE"; }
trap cleanup EXIT HUP INT TERM
for file in $FILES; do
  if [ "$MODE" = safe ] && [ -e "$BIN_DIR/$file" ]; then
    say "Keeping existing $file (safe reinstall)."
    continue
  fi
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
printf '%s\n' "1" > "$CONFIG_DIR/version"
PROFILE_LINE='export PATH="/root/bin:$PATH"'
if [ -f /root/.profile ]; then
  grep -Fq "$PROFILE_LINE" /root/.profile || printf '%s\n' "$PROFILE_LINE" >> /root/.profile
else
  printf '%s\n' "$PROFILE_LINE" > /root/.profile
fi
say "Installation complete. Preferences and display name were preserved."
if [ "$MODE" = safe ]; then say "Existing scripts were kept. Use --update to replace managed scripts."; else say "Updated managed scripts; backups are in $BACKUP_DIR"; fi
say "Launch with: /root/bin/palorder"
"$BIN_DIR/palorder"
