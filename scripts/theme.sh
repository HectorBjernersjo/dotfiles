scriptsDir=$HOME/dotfiles/scripts
if [ "$1" == "Gruvbox Dark" ]; then
	$scriptsDir/nvim_theme.sh gruvbox-material
	$scriptsDir/nvim_background.sh dark
	$scriptsDir/wallpaper_theme.sh gruvbox-dark
	$scriptsDir/tmux_theme.sh gruvbox
	$scriptsDir/waybar_theme.sh gruvbox-light
	$scriptsDir/kitty_theme.sh "Gruvbox Dark"
	$scriptsDir/starship_theme.sh gruvbox
	$scriptsDir/wofi_theme.sh gruvbox
	$scriptsDir/firefox_theme.sh gruvbox
	$scriptsDir/hyprland_theme.sh gruvbox-dark
	$scriptsDir/sway_theme.sh gruvbox-dark
elif [ "$1" == "Gruvbox Light" ]; then
	$scriptsDir/nvim_theme.sh gruvbox-material
	$scriptsDir/nvim_background.sh light
	$scriptsDir/wallpaper_theme.sh gruvbox-light
	$scriptsDir/tmux_theme.sh gruvbox
	$scriptsDir/waybar_theme.sh gruvbox-dark
	$scriptsDir/kitty_theme.sh "Gruvbox Light"
	$scriptsDir/starship_theme.sh gruvbox
	$scriptsDir/wofi_theme.sh gruvbox
	$scriptsDir/firefox_theme.sh gruvbox
	$scriptsDir/hyprland_theme.sh gruvbox-dark
	$scriptsDir/sway_theme.sh gruvbox-dark
elif [ "$1" == "Solarized" ]; then
	$scriptsDir/nvim_theme.sh solarized
	$scriptsDir/nvim_background.sh dark
	$scriptsDir/wallpaper_theme.sh solarized-dark
	$scriptsDir/tmux_theme.sh solarized-dark
	$scriptsDir/waybar_theme.sh solarized-dark
	$scriptsDir/kitty_theme.sh "Solarized Dark"
	$scriptsDir/starship_theme.sh solarized-dark
	$scriptsDir/wofi_theme.sh solarized
	$scriptsDir/firefox_theme.sh solarized
	$scriptsDir/hyprland_theme.sh solarized-dark
	$scriptsDir/sway_theme.sh solarized-dark
elif [ "$1" == "Tokyo Night" ]; then
	$scriptsDir/nvim_theme.sh tokyonight-night
	$scriptsDir/nvim_background.sh dark
	$scriptsDir/wallpaper_theme.sh tokyo-night
	$scriptsDir/tmux_theme.sh tokyo-night
	$scriptsDir/waybar_theme.sh tokyo-night
	$scriptsDir/kitty_theme.sh "Tokyo Night"
	$scriptsDir/starship_theme.sh tokyo-night
	$scriptsDir/wofi_theme.sh tokyo-night
	$scriptsDir/firefox_theme.sh tokyo-night
	$scriptsDir/hyprland_theme.sh tokyo-night
	$scriptsDir/sway_theme.sh tokyo-night
elif [ "$1" == "Everforest Light" ]; then
	$scriptsDir/nvim_theme.sh everforest
	$scriptsDir/nvim_background.sh light
	$scriptsDir/wallpaper_theme.sh everforest-light
	$scriptsDir/tmux_theme.sh everforest
	$scriptsDir/waybar_theme.sh everforest-dark
	$scriptsDir/kitty_theme.sh "Everforest Light Soft"
	$scriptsDir/starship_theme.sh everforest
	$scriptsDir/wofi_theme.sh everforest
	$scriptsDir/firefox_theme.sh everforest
	$scriptsDir/hyprland_theme.sh everforest-light
	$scriptsDir/sway_theme.sh everforest-light
elif [ "$1" == "Everforest Dark" ]; then
	$scriptsDir/nvim_theme.sh everforest
	$scriptsDir/nvim_background.sh dark
	$scriptsDir/wallpaper_theme.sh everforest-dark
	$scriptsDir/tmux_theme.sh everforest
	$scriptsDir/waybar_theme.sh everforest-light
	$scriptsDir/kitty_theme.sh "Everforest Dark Medium"
	$scriptsDir/starship_theme.sh everforest
	$scriptsDir/wofi_theme.sh everforest
	$scriptsDir/firefox_theme.sh everforest
	$scriptsDir/hyprland_theme.sh everforest-dark
	$scriptsDir/sway_theme.sh everforest-dark
fi

	# $scriptsDir/kitty_theme.sh "Everforest Dark Hard"
