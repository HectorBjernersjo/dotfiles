if [ $(cat $HOME/.config/hypr/style.conf | grep cool) ]; then
	echo "source=./basicstyle.conf" > $HOME/.config/hypr/style.conf
else
	echo "source=./coolstyle.conf" > $HOME/.config/hypr/style.conf
fi
