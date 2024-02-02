{ config, lib, pkgs, ... }:
let
  cfg = config.nafiz1001.openbox;
in
{
  imports = [ ./xserver.nix ./minimal.nix ];

  options.nafiz1001.openbox = {
    enable = lib.mkEnableOption "Openbox";
  };

  config = lib.mkIf cfg.enable {
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
    ];
  };  
}
