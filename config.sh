#!/bin/sh

# Set Wayland environment variables
export XDG_CURRENT_DESKTOP=wlroots
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=wlroots

# Update DBus environment in background (non-blocking)
dbus-update-activation-environment --systemd \
    WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP &

# Pipewire is handled by systemd

# Portal setup - kill old instances and restart
pkill -x xdg-desktop-portal-wlr xdg-desktop-portal-gtk xdg-desktop-portal

# Start portals in parallel
{
    /usr/libexec/xdg-desktop-portal-wlr &
    /usr/libexec/xdg-desktop-portal-gtk &
    sleep 0.5
    /usr/libexec/xdg-desktop-portal &
} &

# Set wallpaper
# swaybg -i /home/hans/Pictures/high_sierra.jpg -m fill &

# Start notification daemon
mako &

# Start DWL with slstatus
exec slstatus -s | dwl -s "swaybg -i /home/hans/Pictures/high_sierra.jpg -m fill"
