if [ "$1" == "tokyo-night" ]; then
	theme="tokyonight-night"
elif [ "$1" == "gruvbox-dark" ]; then
	theme="gruvbox-material"
elif [ "$1" == "gruvbox-light" ]; then
	theme="gruvbox-material"
elif [ "$1" == "solarized-dark" ]; then
	theme="solarized"
fi

for server in /tmp/themelistener*; do
    if [ -e "$server" ]; then
        nvim --server "$server" --remote-send ":colorscheme {$theme}<CR>"
    fi
done
echo $theme > ~/dotfiles/.config/nvim/colorscheme.txt
