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
FILES="palorder palorder-boot palorder-ui palorder-setup palorder-packages palorder-update palorder-run-task palorder-utilities"

say() { printf '%s\n' "Palorder iSH: $*"; }
fail() { say "ERROR: $*" >&2; exit 1; }

command -v curl >/dev/null 2>&1 || fail "curl is required. Install it with: apk add curl"
command -v apk >/dev/null 2>&1 || fail "apk was not found. This installer requires a working Alpine/iSH package manager."

mkdir -p "$BIN_DIR" "$CONFIG_DIR" "$BACKUP_DIR"
if ! command -v dialog >/dev/null 2>&1; then
  say "Installing dialog..."
  apk add --no-cache dialog || fail "Could not install dialog. Check network and /etc/apk/repositories."
fi

for file in $FILES; do
  tmp="$BIN_DIR/.$file.tmp.$$"
  say "Downloading $file"
  if ! curl -fLsS --connect-timeout 15 --max-time 120 "$BASE/runtime/$file" -o "$tmp"; then
    rm -f "$tmp"
    fail "Download failed for $file."
  fi
  if [ ! -s "$tmp" ]; then rm -f "$tmp"; fail "Downloaded file is empty: $file"; fi
  if [ -f "$BIN_DIR/$file" ]; then cp "$BIN_DIR/$file" "$BACKUP_DIR/$file"; fi
  chmod 755 "$tmp"
  mv "$tmp" "$BIN_DIR/$file"
done

printf '%s\n' "1" > "$CONFIG_DIR/version"
[ -f "$CONFIG_DIR/settings" ] || printf '%s\n' 'THEME=midnight' 'SHOW_TIPS=1' > "$CONFIG_DIR/settings"
[ -f "$CONFIG_DIR/identity" ] || printf '%s\n' 'Palorder User' > "$CONFIG_DIR/identity"
say "Installation complete. Runtime files only were installed."
say "Launch the menu with: /root/bin/palorder"
say "Backups (if any): $BACKUP_DIR"
"$BIN_DIR/palorder"
