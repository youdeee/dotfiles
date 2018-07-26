#!/bin/sh

ln -sf ~/dotfiles/shell/.zshenv ~/.zshenv
ln -sf ~/dotfiles/shell/.zshrc ~/.zshrc
ln -sf ~/dotfiles/shell/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/shell/.irbrc ~/.irbrc
ln -sf ~/dotfiles/shell/.vimrc ~/.vimrc
ln -sf ~/dotfiles/ergodox_keymaps/youdee ~/qmk_firmware/keyboards/ergodox_ez/keymaps/youdee

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
