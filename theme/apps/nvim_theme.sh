# if [ "$1" == "tokyo-night" ]; then
# 	theme="tokyonight-night"
# elif [ "$1" == "gruvbox-dark" ]; then
# 	theme="gruvbox-material"
# elif [ "$1" == "gruvbox-light" ]; then
# 	theme="gruvbox-material"
# elif [ "$1" == "solarized-dark" ]; then
# 	theme="solarized"
# elif [ "$1" == "catppuccin" ]; then
# 	theme="catppuccin-mocha"
# fi

for server in /tmp/themelistener*; do
    if [ -e "$server" ]; then
        nvim --server "$server" --remote-send ":colorscheme {$1}<CR>"
    fi
done
echo $1 > ~/dotfiles/.config/nvim/colorscheme.txt
