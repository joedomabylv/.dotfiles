# Dotfiles
These are my personal dotfiles. I'm using [GNU stow](https://www.gnu.org/software/stow/) to manage them from the home directory.

I'm going for a literate style, using Emacs Babel/Tangle to write as many dotfiles as I can in org mode. Those files are then tangeled to a file structure that matches that of the local directory. For example, the `/.config/qtile/qtile.py` path in this repo mimics `~/.config/qtile/qtile.py` on my local machine.

## Joemacs
Emacs config heavily inspired by David Wilson

## QTile
Window manager. Dependent on [qtile-extras](https://github.com/elParaguayo/qtile-extras) for border decorations in certain widgets.

**note**: qtile-extras itself is dependent on setuptools being >= version 60 via pip and current Ubuntu LTS (20.04) does not ship that way. Using [get-pip.py](https://github.com/elParaguayo/qtile-extras) solved this issue for qtile/qtile-extras for v0.25.

### Dmenu in Qtile
- The dmenu_run command is dependent on a number of [patches](https://tools.suckless.org/dmenu/patches/):

    **Required**

    - [bar height](https://tools.suckless.org/dmenu/patches/bar_height/)
    - [center](https://tools.suckless.org/dmenu/patches/center/)
    
    **Optional**
    - [border](https://tools.suckless.org/dmenu/patches/border/)
    - [numbers](https://tools.suckless.org/dmenu/patches/numbers/)

### Slock in Qtile
- The startup script and a locking keybind is dependent on [SLock](https://tools.suckless.org/slock/):

## Alacritty
Lightweight terminal config. Dependent on [alacritty-theme](https://github.com/alacritty/alacritty-theme).

**note**: does not have a related org file as babel does not support TOML out of the box