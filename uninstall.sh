#!/bin/sh
set -eu
BIN_DIR="/root/bin"
CONFIG_DIR="/root/.config/palorder"
if command -v dialog >/dev/null 2>&1; then
  dialog --title "Uninstall Palorder iSH" --yesno "Remove Palorder runtime scripts? Preferences, Lua apps and identity will be preserved." 10 64 || exit 0
else
  printf '%s\n' "Remove Palorder runtime scripts? Type yes to continue:"
  IFS= read -r answer
  [ "$answer" = yes ] || exit 0
fi
for file in palorder palorder-boot palorder-ui palorder-setup palorder-settings palorder-packages palorder-update palorder-run-task palorder-utilities palorder-terminal palorder-control palorder-lua-host palorder-app check-update palorder-version pkg-compat apt apt-get pacman palorder-shell palorder-network palorder-dev palorder-history palorder-changelog; do rm -f "$BIN_DIR/$file"; done
for dev in urandom random null zero; do
  path="/dev/palorder/$dev"
  if [ -L "$path" ] && [ "$(readlink "$path" 2>/dev/null || :)" = "/dev/$dev" ]; then rm -f "$path"; fi
done
rmdir /dev/palorder 2>/dev/null || :
printf '%s\n' "Palorder runtime scripts removed. Preferences and apps remain under $CONFIG_DIR and ~/.local/share/palorder."
