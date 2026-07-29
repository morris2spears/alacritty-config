#!/usr/bin/env bash
# Per-monitor font scaling for Alacritty on X11.
#
# X11 exposes only a single global DPI, but this machine mixes a ~244-DPI laptop
# panel (eDP-1) with a ~109-DPI HDMI monitor. The alacritty.toml base font size
# is tuned for the HDMI; here we scale the window up when it opens on the dense
# laptop panel so text stays the same *physical* size on both screens.
#
# Detect the output of the currently focused i3 workspace (that's where i3 will
# place the new window) and set winit's scale-factor override accordingly.

out=$(i3-msg -t get_workspaces 2>/dev/null \
  | python3 -c 'import sys,json; print(next((w["output"] for w in json.load(sys.stdin) if w["focused"]), ""))' 2>/dev/null)

case "$out" in
  eDP-*) export WINIT_X11_SCALE_FACTOR=2.0 ;;  # high-DPI laptop panel -> scale up
  *)     export WINIT_X11_SCALE_FACTOR=1.0 ;;  # HDMI / external -> base size
esac

exec alacritty "$@"
