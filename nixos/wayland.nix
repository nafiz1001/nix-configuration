{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.nafiz1001.wayland;
in
{
  options.nafiz1001.wayland = {
    enable = lib.mkEnableOption "Base Wayland Config";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays =
      [ (self: super: { eww = super.eww.override { withWayland = true; }; }) ];

    environment.systemPackages = with pkgs; [
      wl-clipboard
      xwaylandvideobridge # screensharing

      libsForQt5.qt5.qtwayland
      qt6.qtwayland

      swaybg
      # swww # animated background
    ];
  };
}
