echo "@import 'themes/$1.css';" > $HOME/.config/waybar/theme.css
pkill waybar
waybar &
