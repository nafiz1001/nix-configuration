{ config, lib, pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.autorun = true;
  services.xserver = {
    libinput = {
      enable = true;

      # disabling mouse acceleration
      mouse = {
        accelProfile = "flat";
      };

      # disabling touchpad acceleration
      touchpad = {
        accelProfile = "flat";
      };
    };
  };
  services.xserver = {
    excludePackages = [ pkgs.xterm ];
  };

  programs.dconf.enable = true;
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  services.gnome.gnome-keyring.enable = true;

  fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

  environment.systemPackages = with pkgs; [
    xclip
    dmenu
  ];
}
