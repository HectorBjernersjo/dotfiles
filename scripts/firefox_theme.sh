FIREFOX_CHROME_PATH="$HOME/.mozilla/firefox/$(ls $HOME/.mozilla/firefox | grep default-release)/chrome"
echo $FIREFOX_CHROME_PATH
cp "$HOME/dotfiles/wallpapers/firefox/$1.png" "$FIREFOX_CHROME_PATH/background.png"
