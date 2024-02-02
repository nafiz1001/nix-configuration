{ config, lib, pkgs, ... }:
let
  cfg = config.nafiz1001.gnome;
in
{
  imports = [ ./xserver.nix ./wayland.nix ];

  options.nafiz1001.gnome = {
    enable = lib.mkEnableOption "Gnome";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.displayManager.gdm.enable = true;

    services.xserver.desktopManager.gnome.enable = true;

    services.gnome = {
      games.enable = false;
      core-developer-tools.enable = false;
    };

    environment.gnome.excludePackages = (with pkgs; [
      # gnome-photos
      gnome-text-editor
      gnome-tour
      snapshot # webcam
    ]) ++ (with pkgs.gnome; [
      baobab # disk usage analyzer
      cheese # webcam tool
      epiphany # web browser
      evince # document viewer
      geary # email reader
      gedit # text editor
      gnome-calendar
      # gnome-characters
      gnome-contacts
      gnome-maps
      gnome-music
      gnome-software
      gnome-terminal
      gnome-weather
      simple-scan
      totem # video player but i already need mpv
      yelp # help viewer
    ]);

    environment.systemPackages = with pkgs; [
      gnome-extension-manager
      gnome.gnome-tweaks
      gnomeExtensions.gsconnect

      mpv # video and (most importantly) music player
      mpvScripts.inhibit-gnome

      kitty
    ];

    # nixos/modules/config/qt.nix
    qt = {
      enable = true;
    };
  };
}
