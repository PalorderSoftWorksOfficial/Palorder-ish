#!/bin/sh
set -eu
BIN_DIR="/root/bin"
CONFIG_DIR="/root/.config/palorder"
if command -v dialog >/dev/null 2>&1; then
  dialog --title "Uninstall Palorder iSH" --yesno "Remove Palorder runtime scripts? Settings and identity will be preserved." 10 58 || exit 0
else
  printf '%s\n' "Remove Palorder runtime scripts? Type yes to continue:"
  read answer
  [ "$answer" = yes ] || exit 0
fi
for file in palorder palorder-boot palorder-ui palorder-setup palorder-packages palorder-update palorder-run-task palorder-utilities; do rm -f "$BIN_DIR/$file"; done
printf '%s\n' "Palorder runtime scripts removed. Settings remain in $CONFIG_DIR."
