{ config, lib, pkgs, username, ... }:
let
  cfg = config.nafiz1001.sway;
in
{
  imports = [ ./wayland.nix ./minimal.nix ];

  options.nafiz1001.sway = {
    enable = lib.mkEnableOption "Sway";
  };

  config = lib.mkIf cfg.enable {
    nafiz1001.wayland.enable = true;
    nafiz1001.minimal.enable = true;

    programs.sway = {
      enable = true;
    };
    xdg.portal = {
      wlr.enable = true;
      # config.common = {
      #   "org.freedesktop.impl.portal.Screenshot" = "wlr";
      #   "org.freedesktop.impl.portal.ScreenCast" = "wlr";
      # };
    };

    programs.waybar.enable = true;

    # https://nixos.wiki/wiki/Sway#Brightness_and_volume
    programs.light.enable = true;
    users.users.${username}.extraGroups = [ "video" ];
    users.users.root.extraGroups = [ "video" ];

    services.greetd = {
      enable = false;
      settings = {
        default_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd sway";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      sway-audio-idle-inhibit
      sway-contrib.grimshot
      obs-studio-plugins.wlrobs

      mako # notification system developed by swaywm maintainer

      fuzzel
    ];
  };
}
