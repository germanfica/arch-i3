#!/usr/bin/env bash
set -e

sudo pacman -Syu --needed \
  xorg-server \
  xorg-xinit \
  i3-wm \
  dmenu \
  alacritty

cat > "$HOME/.xinitrc" <<'EOF'
exec i3
EOF

echo "Installation complete. You can start i3 with:"
echo "startx"