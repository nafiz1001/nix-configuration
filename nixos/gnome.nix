{ config, lib, pkgs, ... }:
let cfg = config.nafiz1001.gnome;
in {
  imports = [ ./xserver.nix ./wayland.nix ];

  options.nafiz1001.gnome = { enable = lib.mkEnableOption "Gnome"; };

  config = lib.mkIf cfg.enable {
    nafiz1001.xserver.enable = true;
    nafiz1001.wayland.enable = true;

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
      gedit # text editor
    ]) ++ (with pkgs.gnome; [
      # baobab # disk usage analyzer
      cheese # webcam tool
      epiphany # web browser
      evince # document viewer
      geary # email reader
      gnome-calendar
      # gnome-characters
      gnome-contacts
      gnome-maps
      gnome-music
      gnome-software
      gnome-terminal
      gnome-weather
      simple-scan
      totem # video player but mpv is better
      yelp # help viewer
    ]);

    environment.systemPackages = with pkgs; [
      gnome-extension-manager
      gnome.gnome-tweaks
      gnomeExtensions.gsconnect
      gnomeExtensions.appindicator

      mpv # video and (most importantly) music player
      mpvScripts.inhibit-gnome
    ];

    programs.firefox.nativeMessagingHosts.packages = with pkgs;
      [ gnomeExtensions.gsconnect ];

    # nixos/modules/config/qt.nix
    qt = { enable = true; };

    environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 =
      lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with pkgs.gst_all_1; [
        gst-plugins-good
        gst-plugins-bad
        gst-plugins-ugly
        gst-libav
      ]);
  };
}
