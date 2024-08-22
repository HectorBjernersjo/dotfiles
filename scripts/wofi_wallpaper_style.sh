selection=$(ls "$HOME/dotfiles/wallpapers/$(cat $HOME/dotfiles/wallpapers/theme.txt)" | wofi --dmenu --prompt="Select wallpaper style...")

$HOME/dotfiles/scripts/wallpaper_style.sh "$selection"
