theme=$1

if [ "$theme" == "tokyo-night" ]; then
    echo 'set -g @plugin "janoamaral/tokyo-night-tmux"' > $HOME/.config/tmux/theme.conf
elif [ "$theme" == "gruvbox-dark" ]; then
    echo "set -g @plugin 'egel/tmux-gruvbox'" > $HOME/.config/tmux/theme.conf
	echo "set -g @tmux-gruvbox 'dark'" >> $HOME/.config/tmux/theme.conf
else
    echo "Theme not recognized"
    exit 1
fi
#
# tmux source-file $HOME/.config/tmux/themes/$1.conf
# $HOME/.tmux/plugins/tpm/bin/install_plugins
tmux source-file $HOME/.config/tmux/tmux.conf
