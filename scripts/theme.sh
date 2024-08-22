if [ "$1" == "gruvbox-dark" ]; then
	./nvim_theme.sh $1
	./wallpaper_switcher.sh $1
	./tmux_theme.sh $1
	./waybar_theme.sh gruvbox-light
	./kitty_theme.sh $1
	./starship_theme.sh gruvbox
elif [ "$1" == "tokyo-night" ]; then
	./nvim_theme.sh $1
	./wallpaper_switcher.sh $1
	./tmux_theme.sh $1
	./waybar_theme.sh $1
	./kitty_theme.sh $1
	./starship_theme.sh $1
fi

./hyprland_theme.sh $1
