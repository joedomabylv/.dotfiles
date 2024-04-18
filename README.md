# Dotfiles
These are my personal dotfiles. I'm using [GNU stow](https://www.gnu.org/software/stow/) to manage them from the home directory.

I'm going for a literate style, using Emacs Babel/Tangle to write as many dotfiles as I can in org mode. Those files are then tangeled to a file structure that matches that of the local directory. For example, the `/.config/qtile/qtile.py` path in this repo mimics `~/.config/qtile/qtile.py` on my local machine.

## Joemacs
Emacs config heavily inspired by David Wilson

## QTile
Window manager

## Alacritty
Lightweight terminal config. Dependent on [alacritty-theme](https://github.com/alacritty/alacritty-theme).

**note**: does not have a related org file as babel does not support TOML out of the box