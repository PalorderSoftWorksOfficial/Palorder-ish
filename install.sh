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

STAGE="$CONFIG_DIR/install-stage.$"
mkdir -p "$STAGE"
cleanup() { rm -rf "$STAGE"; }
trap cleanup EXIT HUP INT TERM

for file in $FILES; do
  say "Downloading $file"
  if ! curl -fLsS --connect-timeout 15 --max-time 120 "$BASE/runtime/$file" -o "$STAGE/$file"; then
    fail "Download failed for $file. Existing runtime files were not replaced."
  fi
  [ -s "$STAGE/$file" ] || fail "Downloaded file is empty: $file"
  chmod 755 "$STAGE/$file"
done

for file in $FILES; do
  if [ -f "$BIN_DIR/$file" ]; then cp "$BIN_DIR/$file" "$BACKUP_DIR/$file"; fi
  mv "$STAGE/$file" "$BIN_DIR/$file"
done

printf '%s\n' "1" > "$CONFIG_DIR/version"
if [ -f /root/.profile ]; then
  grep -q 'export PATH="/root/bin:$PATH"' /root/.profile || printf '%s\n' 'export PATH="/root/bin:$PATH"' >> /root/.profile
else
  printf '%s\n' 'export PATH="/root/bin:$PATH"' > /root/.profile
fi
[ -f "$CONFIG_DIR/settings" ] || printf '%s\n' 'THEME=midnight' 'SHOW_TIPS=1' > "$CONFIG_DIR/settings"
[ -f "$CONFIG_DIR/identity" ] || printf '%s\n' 'Palorder User' > "$CONFIG_DIR/identity"
say "Installation complete. Runtime files only were installed."
say "Launch the menu with: /root/bin/palorder"
say "Backups (if any): $BACKUP_DIR"
"$BIN_DIR/palorder"
