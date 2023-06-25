{ config, lib, pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.autorun = true;
  services.xserver = {
    libinput = {
      enable = true;

      # disabling mouse acceleration
      mouse = { accelProfile = "flat"; };

      # disabling touchpad acceleration
      touchpad = { accelProfile = "flat"; };
    };
  };
  services.xserver = { excludePackages = [ pkgs.xterm ]; };

  services.xserver.windowManager.openbox.enable = true;

  services.redshift = {
    enable = true;
    temperature = { night = 1000; };
  };
  location = { provider = "geoclue2"; };
  services.geoclue2.appConfig.redshift.isAllowed = true;

  environment.systemPackages = with pkgs; [
    konsole
    xclip
    dmenu
    tint2
    flameshot
  ];
}
