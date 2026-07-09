sudo ln -sf /home/hector/dotfiles/.config/kanata/config.kbd /etc/kanata/kanata.kbd
sudo systemctl daemon-reload
sudo systemctl enable --now kanata.service
