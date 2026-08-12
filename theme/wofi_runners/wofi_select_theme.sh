command_file=$HOME/dotfiles/theme/themes.txt

selection=$(cat "$command_file" | wofi --dmenu --prompt="Select Theme:")

if [ -n "$selection" ]; then
	$HOME/dotfiles/theme/theme.sh "$selection"
fi
