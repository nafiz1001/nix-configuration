{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  qt5 = {
    enable = true;
    platformTheme = "qt5ct";
    style = "adwaita-dark";
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome.epiphany
  ];

  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnome.adwaita-icon-theme
    gnomeExtensions.appindicator
  ];
}
