{ config, lib, pkgs, ... }:

{
  services.xserver.windowManager.openbox.enable = true;
  services.xserver.autorun = true;

  services.redshift = {
    enable = true;
    temperature = { night = 1000; };
  };
  location = { provider = "geoclue2"; };
  services.geoclue2.appConfig.redshift.isAllowed = true;
  
  environment.systemPackages = with pkgs; [
    dmenu
    tint2
    flameshot
    gwenview
  ];
}
