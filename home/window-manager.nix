{ config, pkgs, lib, osConfig, ... }:
let
  cfg = config.nafiz1001.window-manager;
in
{
  options.nafiz1001.window-manager = {
    enable = lib.mkEnableOption "Window Manager";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      pavucontrol
      pamixer

      gwenview
      mpv
      xfce.thunar

      polkit-kde-agent

      gammastep
    ];
  };
}
