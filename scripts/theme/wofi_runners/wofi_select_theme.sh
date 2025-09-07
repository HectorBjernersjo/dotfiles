command_file=$HOME/dotfiles/scripts/theme/themes.txt

selection=$(cat "$command_file" | wofi --dmenu --prompt="Select Theme:")

if [ -n "$selection" ]; then
	$HOME/dotfiles/scripts/theme/theme.sh "$selection"
fi
