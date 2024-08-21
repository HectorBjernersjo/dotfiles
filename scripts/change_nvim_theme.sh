for server in /tmp/tjabba*; do
    if [ -e "$server" ]; then
        nvim --server "$server" --remote-send ":colorscheme {$1}<CR>"
    fi
done
echo $1 > ~/dotfiles/.config/nvim/colorscheme.txt
