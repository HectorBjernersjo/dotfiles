./nvim_theme.sh tokyonight-night
kitten themes --reload-in=all Tokyo Night

./wallpaper_switcher.sh tokyo-night
./tmux_theme.sh tokyo-night
echo '@import "themes/tokyo-night/main.css";' > ~/.config/waybar/theme.css
killall waybar
waybar &
