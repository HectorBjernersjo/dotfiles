for server in /tmp/themelistener*; do
    if [ -e "$server" ]; then
        nvim --server "$server" --remote-send ":set background=$1<CR>"
    fi
done
echo $1 > ~/.config/nvim/background.txt
