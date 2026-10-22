#!/usr/bin/env bash
set -e

sudo pacman -Syu --needed \
  xorg-server \
  xorg-xinit \
  i3-wm \
  dmenu \
  alacritty </dev/tty

cat > "$HOME/.xinitrc" <<'EOF'
exec i3
EOF

cat >> "$HOME/.bash_profile" <<'EOF'

if [[ -z "$DISPLAY" && "$(tty)" == "/dev/tty1" ]]; then
  exec startx
fi
EOF

echo "Installation complete. i3 will start automatically after login on TTY1."