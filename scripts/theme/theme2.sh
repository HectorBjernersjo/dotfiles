#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Validation ---
THEME="$1"
VALID_THEMES=("everforest-dark" "everforest-light" "gruvbox-dark" "gruvbox-light" "solarized-dark" "tokyo-night")

# Check if the provided theme is in our valid list.
# The `|| exit 1` makes the script stop if the theme is not found.
if ! (printf "%s\n" "${VALID_THEMES[@]}" | grep -qx -- "$THEME"); then
    echo "Error: Theme '$THEME' does not exist." >&2
    exit 1
fi

echo "🚀 Applying theme: $THEME"

# --- Starship ---
case "$THEME" in
    "everforest-dark")  STARSHIP_THEME="everforest"  ;;
    "everforest-light") STARSHIP_THEME="everforest" ;;
    "gruvbox-dark")     STARSHIP_THEME="gruvbox"          ;;
    "gruvbox-light")    STARSHIP_THEME="gruvbox"         ;;
    "solarized-dark")   STARSHIP_THEME="solarized-dark"        ;;
    "tokyo-night")      STARSHIP_THEME="tokyo-night"           ;;
esac
cp "$HOME/.config/starship/$STARSHIP_THEME.toml" "$HOME/.config/starship.toml"

# --- Sway / Hyprland ---
# You can use the same theme file for both if they follow a similar format
echo "include ./themes/$THEME" > "$HOME/.config/sway/theme"
swaymsg reload &> /dev/null

echo "source=./themes/$THEME.conf" > "$HOME/.config/hypr/theme.conf"

# --- Kitty ---
case "$THEME" in
    "everforest-dark")  KITTY_THEME="Everforest Dark Hard"  ;;
    "everforest-light") KITTY_THEME="Everforest Light Soft" ;;
    "gruvbox-dark")     KITTY_THEME="Gruvbox Dark"          ;;
    "gruvbox-light")    KITTY_THEME="Gruvbox Light"         ;;
    "solarized-dark")   KITTY_THEME="Solarized Dark"        ;;
    "tokyo-night")      KITTY_THEME="Tokyo Night"           ;;
esac
kitten themes --reload-in=all "$KITTY_THEME"

# --- Neovim ---
# This part is still limited to your original logic, but with corrected syntax
if [[ "$THEME" == "gruvbox-dark" ]]; then
    for server in /tmp/themelistener*; do
        if [ -S "$server" ]; then # Check if it's a socket
            nvim --server "$server" --remote-send ":colorscheme gruvbox<CR>"
            nvim --server "$server" --remote-send ":set background=dark<CR>"
        fi
    done
    echo "gruvbox" > "$HOME/.config/nvim/colorscheme.txt"
    echo "dark" > "$HOME/.config/nvim/background.txt"
else
    echo "🤔 Neovim theme not configured for '$THEME'. Manual update may be needed."
fi

# --- Tmux ---
TMUX_CONF_FILE="$HOME/.config/tmux/theme.conf"
case "$THEME" in
    "tokyo-night")
        echo 'set -g @plugin "janoamaral/tokyo-night-tmux"' > "$TMUX_CONF_FILE"
        ;;
    "solarized-dark")
        echo 'set -g @plugin "mkoga/tmux-solarized"' > "$TMUX_CONF_FILE"
        ;;
    "gruvbox-dark")
        echo "set -g @plugin 'egel/tmux-gruvbox'" > "$TMUX_CONF_FILE"
        echo "set -g @tmux-gruvbox 'dark'" >> "$TMUX_CONF_FILE"
        ;;
    "everforest-dark"|"everforest-light")
        echo "set -g @plugin 'TanglingTreats/tmux-everforest'" > "$TMUX_CONF_FILE"
        ;;
    *)
        echo "# No tmux plugin configured for theme '$THEME'" > "$TMUX_CONF_FILE"
        ;;
esac
tmux source-file "$TMUX_CONF_FILE"

# --- Wofi ---
case "$THEME" in
    "everforest-dark"|"everforest-light") WOFI_THEME="everforest" ;;
    "gruvbox-dark"|"gruvbox-light")     WOFI_THEME="gruvbox"    ;;
    "solarized-dark")                   WOFI_THEME="solarized"  ;;
    "tokyo-night")                      WOFI_THEME="tokyo-night" ;;
esac
echo "@import 'themes/$WOFI_THEME.css';" > "$HOME/.config/wofi/theme.css"

# --- Firefox ---
# Note: This is a fragile way to find the profile, but it works for simple setups.
FIREFOX_PROFILE_DIR=$(find "$HOME/.mozilla/firefox/" -name "*.default-release" -type d | head -n 1)
if [[ -d "$FIREFOX_PROFILE_DIR" ]]; then
    FIREFOX_CHROME_PATH="$FIREFOX_PROFILE_DIR/chrome"
    mkdir -p "$FIREFOX_CHROME_PATH"
    cp "$HOME/dotfiles/firefox/wallpapers/$THEME.png" "$FIREFOX_CHROME_PATH/background.png"
else
    echo "⚠️ Could not find Firefox default-release profile directory."
fi

echo "✅ Theme set successfully!"
