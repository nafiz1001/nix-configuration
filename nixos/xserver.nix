{ config, lib, pkgs, ... }:
let
  cfg = config.nafiz1001.xserver;
in
{
  options.nafiz1001.xserver = {
    enable = lib.mkEnableOption "Base XOrg Config";
  };

  config = lib.mkIf cfg.enable
    {
      services.xserver = {
        enable = true;
        excludePackages = [ pkgs.xterm ];
      };

      environment.systemPackages = with pkgs; [
        xclip
      ];
    };
}
