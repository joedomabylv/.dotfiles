# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess
import colors
from libqtile import bar, layout, qtile, hook, extension
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from qtile_extras.widget.decorations import BorderDecoration
from qtile_extras import widget
from libqtile.lazy import lazy

mod = "mod4"
terminal = "alacritty"
palette = colors.RosePine

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between window
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Grow/shrink stack using MonadTall layout
    Key([mod], "i", lazy.layout.grow()),
    Key([mod], "m", lazy.layout.shrink()),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "Tab", lazy.next_screen(), desc="Move focus to next monitor"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod, "shift"], "i", lazy.spawn("slock"), desc="Slock X session"),
    Key([mod], "p", lazy.run_extension(extension.DmenuRun(
        dmenu_prompt="app >",
        dmenu_font="Source Code Pro",
        dmenu_command="dmenu_run -c -l 20 -bw 3",
        background=palette[0],
        foreground=palette[1],
        selected_background=palette[3],
        selected_foreground=palette[1],
    ))),
]

groups = []
group_names = ["1", "2", "3", "4", "5"]
group_labels = ["one", "two", "three", "four", "five"]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            label=group_labels[i],
        )
    )

for i in groups:
    keys.extend(
        [
            # mod1 + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layout_theme = dict(
    border_width=2,
    margin=4,
    border_focus=palette[3],
)

layouts = [
    # layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    # layout.Max(**layout_theme),
    # layout.Stack(**layout_theme, num_stacks=2),
    # layout.Bsp(**layout_theme),
    # layout.Matrix(**layout_theme),
    layout.MonadTall(**layout_theme),
    # layout.MonadWide(**layout_theme),
    # layout.RatioTile(**layout_theme),
    # layout.Tile(**layout_theme),
    # layout.TreeTab(**layout_theme),
    # layout.VerticalTile(**layout_theme),
    # layout.Zoomy(**layout_theme),
]

widget_defaults = dict(
    font="Source Sans 3",
    fontsize=14,
    padding=10,
    background=palette[0],
    foreground=palette[1],
)

border_width = [0, 0, 3, 0]
extension_defaults = widget_defaults.copy()

# Bar widgets
window_name = widget.WindowName(padding=10)
group_box = widget.GroupBox(
    highlight_method="line",
    highlight_color=palette[4],
    this_current_screen_border=palette[5],
    inactive=palette[5])
system_tray = widget.Systray(
                    decorations=[
                        BorderDecoration(
                            colour = palette[2],
                            border_width = border_width,
                        )])
pulse_volume = widget.PulseVolume(
                    mouse_callbacks={
                        "Button1": lazy.spawn("pavucontrol"),  
                    },
                    fmt="Audio: {}",
                    volume_app="pulseaudio",
                    decorations=[
                        BorderDecoration(
                            colour = palette[3],
                            border_width = border_width,
                        )])
cpu = widget.CPU(
                    format = '▓  CPU: {load_percent}%',
                    decorations=[
                        BorderDecoration(
                            colour = palette[4],
                            border_width = border_width,
                        )])
clock = widget.Clock(
                    format="%m/%d/%y %a %I:%M %p",
                    decorations=[
                        BorderDecoration(
                            colour = palette[5],
                            border_width = border_width,
                        )])
open_weather = widget.OpenWeather(
                    cityid="5391811", # san diego, ca
                    metric=False,     # imperial (F)
                    format="{icon} {temp}°",
                    decorations=[
                        BorderDecoration(
                            colour = palette[6],
                            border_width = border_width,
                        )])
battery = widget.Battery(
                    discharge_char='',
                    charge_char='⚡',
                    full_char='⚡',
                    show_short_text=False,
                    low_percentage=0.2,
                    low_foreground='#D80F0F',
                    format='{char} {percent:2.0%}',
                    decorations=[
                        BorderDecoration(
                            colour = palette[1],
                            border_width = border_width,
                        )])

main_bar = bar.Bar([
    window_name,
    group_box,
    widget.Spacer(),
    system_tray,
    pulse_volume,
    cpu,
    clock,
    open_weather,
    battery],
    30,
    opacity=1)

secondary_bar = bar.Bar([
        window_name,
        clock],
        30,
        opacity=1)

screens = [
    Screen(
        top=main_bar,
        wallpaper="/usr/share/backgrounds/new-zealand.jpg",
        wallpaper_mode="fill"
    ),
    Screen(
        top=secondary_bar,
        wallpaper="/usr/share/backgrounds/new-zealand.jpg",
        wallpaper_mode="fill"
    ),    
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.Popen([home])
