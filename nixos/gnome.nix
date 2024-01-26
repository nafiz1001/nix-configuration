{ config, lib, pkgs, ... }: {
  services.xserver.displayManager.gdm.enable = true;

  services.xserver.desktopManager.gnome.enable = true;

  services.gnome = {
    games.enable = false;
    core-developer-tools.enable = false;
  };

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
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
    # gnome-terminal
    gnome-weather
    simple-scan
    totem # video player
    yelp # help viewer
  ]);

  environment.systemPackages = with pkgs; [
    gnome-extension-manager
    gnome.gnome-tweaks
    gnomeExtensions.gsconnect
  ];

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
}
