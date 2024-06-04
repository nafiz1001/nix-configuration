{ config, pkgs, lib, osConfig, ... }:
let
  cfg = config.nafiz1001.sway;
in
{
  imports = [ ./waybar.nix ./wayland.nix ./window-manager.nix ];

  options.nafiz1001.sway = {
    enable = lib.mkEnableOption "Sway";
  };

  config = lib.mkIf cfg.enable {
    nafiz1001.window-manager.enable = true;
    nafiz1001.waybar.enable = true;
    nafiz1001.wayland.enable = true;

    wayland.windowManager.sway = {
      enable = true;
      systemd.enable = true;
      systemd.xdgAutostart = true;
      config = {
        modifier = "Mod4";
        bars = [];
      };
    };

    xdg.portal = {
      enable = true;
      xdg.portal.extraPortals = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
      ];
      config.common = {
        default = "gtk";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
        "org.freedesktop.impl.portal.ScreenCast" = "wlr";
      }
    };
    
    programs.fuzzel.enable = true;
    services.mako.enable = true;

    home.packages = with pkgs; [
      foot

      sway-audio-idle-inhibit
      sway-contrib.grimshot
      obs-studio-plugins.wlrobs

      swaybg
      # swww # animated background
    ];
  };
}
