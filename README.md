# Dotfiles
These are my personal dotfiles. I'm using [GNU stow](https://www.gnu.org/software/stow/) to manage them from the home directory. This file structure mimics that of a `home` directory in Ubuntu. This allows the following commands:

```
cd ~/.dotfiles
stow -t ~ home
```

I'm going for a literate style, using Emacs Babel/Tangle to write as many dotfiles as I can in org mode. Those files are then tangeled to a file structure that matches that of the local directory. For example, the `/home/.config/qtile/qtile.py` path in this repo mimics `~/.config/qtile/qtile.py` on my local machine.

## Joemacs
Emacs config heavily inspired by David Wilson

## QTile
Window manager. Dependent on [qtile-extras](https://github.com/elParaguayo/qtile-extras) for border decorations in certain widgets.

## i3

### i3lock-color
Dependent on a better version of i3lock, [i3lock-color](https://github.com/Raymo111/i3lock-color)

Note this overwrites the vanilla i3lock.

The default Ubuntu instructions mostly worked for me except I installed in a `/tmp` folder and had to manually run `./install-i3lock-color.sh`, which installed to `/usr/bin/` which I didn't want. After it built, I was able to build again by running:
```
sudo make install prefix=/usr/local
hash -r
```
and subsequently reinstalling the vanilla version of i3lock. There might be clearer instructions somewhere else.

### Rofi
Application launcher tool.

I used to use Dmenu but I find that Rofi is much more configurable and doesn't require manual patching.

### Slock in Qtile
- The startup script and a locking keybind is dependent on [SLock](https://tools.suckless.org/slock/)

## Alacritty
Lightweight terminal config.

**note**: does not have a related org file as babel does not support TOML out of the box