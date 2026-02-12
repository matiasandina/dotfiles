#!/usr/bin/env bash
set -euo pipefail

CONF_DIR="/etc/systemd/logind.conf.d"
CONF_FILE="${CONF_DIR}/lid.conf"

echo "Configuring systemd logind lid behavior (safe mode)"

# Ensure drop-in directory exists
if [[ ! -d "$CONF_DIR" ]]; then
  echo "Creating $CONF_DIR"
  sudo mkdir -p "$CONF_DIR"
fi

# Write config
echo "Writing $CONF_FILE"
sudo tee "$CONF_FILE" > /dev/null <<'EOF'
[Login]
HandleLidSwitch=suspend
HandleLidSwitchExternalPower=suspend
HandleLidSwitchDocked=ignore
LidSwitchIgnoreInhibited=yes
EOF

echo
echo "==== lid.conf ===="
sudo cat "$CONF_FILE"
echo "=================="
echo

echo "Config written."
echo "No restart performed (avoids session lockup)."
echo "Settings will apply on next lid event or after reboot."

echo
echo "Current inhibitors (informational):"
gnome-session-inhibit --list || true

