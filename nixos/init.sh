#!/bin/sh

SCRIPT_PATH=$(dirname $(realpath -s $0))
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

dconf load / < gnome-settings.ini

mkdir -p $XDG_CONFIG_HOME/mpv
ln -s $SCRIPT_PATH/mpv.conf $XDG_CONFIG_HOME/mpv/mpv.conf

mkdir -p $XDG_CONFIG_HOME/hypr
ln -s $SCRIPT_PATH/hyprland.conf $XDG_CONFIG_HOME/hypr/hyprland.conf 

mkdir -p $XDG_CONFIG_HOME/waybar
ln -s $SCRIPT_PATH/waybar.json $XDG_CONFIG_HOME/waybar/config.jsonc
