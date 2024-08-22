scriptsDir=$HOME/dotfiles/scripts
if [ "$1" == "gruvbox-dark" ]; then
	$scriptsDir/nvim_theme.sh $1
	$scriptsDir/wallpaper_theme.sh $1
	$scriptsDir/tmux_theme.sh gruvbox
	$scriptsDir/waybar_theme.sh gruvbox-light
	$scriptsDir/kitty_theme.sh $1
	$scriptsDir/starship_theme.sh gruvbox
	$scriptsDir/wofi_theme.sh gruvbox
	$scriptsDir/firefox_theme.sh gruvbox
elif [ "$1" == "gruvbox-light" ]; then
	$scriptsDir/nvim_theme.sh $1
	$scriptsDir/wallpaper_theme.sh $1
	$scriptsDir/tmux_theme.sh gruvbox
	$scriptsDir/waybar_theme.sh gruvbox-dark
	$scriptsDir/kitty_theme.sh $1
	$scriptsDir/starship_theme.sh gruvbox
	$scriptsDir/wofi_theme.sh gruvbox
	$scriptsDir/firefox_theme.sh gruvbox
elif [ "$1" == "solarized-dark" ]; then
	$scriptsDir/nvim_theme.sh $1
	$scriptsDir/wallpaper_theme.sh $1
	$scriptsDir/tmux_theme.sh $1
	$scriptsDir/waybar_theme.sh $1
	$scriptsDir/kitty_theme.sh $1
	$scriptsDir/starship_theme.sh $1
	$scriptsDir/wofi_theme.sh solarized
	$scriptsDir/firefox_theme.sh solarized
elif [ "$1" == "tokyo-night" ]; then
	$scriptsDir/nvim_theme.sh $1
	$scriptsDir/wallpaper_theme.sh $1
	$scriptsDir/tmux_theme.sh $1
	$scriptsDir/waybar_theme.sh $1
	$scriptsDir/kitty_theme.sh $1
	$scriptsDir/starship_theme.sh $1
	$scriptsDir/wofi_theme.sh $1
	$scriptsDir/firefox_theme.sh tokyo-night
fi

$scriptsDir/hyprland_theme.sh $1
