echo "@import 'themes/$1.css';" > ~/.config/waybar/theme.css
killall waybar
waybar &
