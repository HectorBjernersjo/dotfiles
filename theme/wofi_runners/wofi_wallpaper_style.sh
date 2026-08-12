selection=$(echo -e "all\n$(ls "$HOME/dotfiles/wallpapers/$(cat $HOME/dotfiles/wallpapers/theme.txt)")" | wofi --dmenu --prompt="Select wallpaper style...")

if [ -n "$selection" ]; then
	$HOME/dotfiles/theme/wallpaper/wallpaper_style.sh "$selection"
fi
