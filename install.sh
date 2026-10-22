
#!/usr/bin/env bash
set -Eeuo pipefail

# Install i3, LightDM, and Polybar on Arch Linux.
# Run as a regular user: ./install.sh

trap 'printf "\n[ERROR] Command failed at line %s.\n" "$LINENO" >&2' ERR

info() { printf '\n[INFO] %s\n' "$*"; }
die() { printf '[ERROR] %s\n' "$*" >&2; exit 1; }

[[ ${EUID} -ne 0 ]] || die 'Do not run this script as root. Run it as a regular user.'
command -v pacman >/dev/null 2>&1 || die 'This script requires Arch Linux or a pacman-based distribution.'
command -v sudo >/dev/null 2>&1 || die 'sudo was not found.'
[[ -r /dev/tty && -w /dev/tty ]] || die 'An interactive terminal is required.'

packages=(
  git
  i3-wm i3status i3lock dmenu rofi feh alacritty
  lightdm lightdm-gtk-greeter
  ttf-jetbrains-mono-nerd
  polybar
)

info 'Installing packages from the official repositories...'
sudo pacman -Syu --needed "${packages[@]}" </dev/tty

info 'Enabling LightDM to start automatically on the next boot...'
sudo systemctl enable lightdm.service </dev/tty

repo_dir="${HOME}/.local/src/polybar-themes"
mkdir -p "$(dirname "$repo_dir")"

if [[ -d "$repo_dir/.git" ]]; then
  info "The repository already exists at $repo_dir; no changes will be made."
elif [[ -e "$repo_dir" ]]; then
  die "The path $repo_dir already exists and is not a Git repository. Please review it manually."
else
  info 'Cloning Polybar themes...'
  git clone --depth=1 https://github.com/adi1090x/polybar-themes.git "$repo_dir"
fi

[[ -f "$repo_dir/setup.sh" ]] || die "The Polybar theme installer was not found at $repo_dir/setup.sh."

info 'Starting the interactive Polybar theme installer...'
info 'Review setup.sh before proceeding if you have not verified the repository.'
(
  cd "$repo_dir"
  bash ./setup.sh </dev/tty
)

printf '\n[OK] Installation completed successfully.\n'
printf 'Restart your system when convenient and select the i3 session in LightDM.\n'
printf 'To launch an installed theme: bash ~/.config/polybar/launch.sh --hack\n'
