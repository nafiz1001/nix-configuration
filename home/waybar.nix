{ config, pkgs, lib, osConfig, ... }:
let
  cfg = config.nafiz1001.waybar;
in
{
  options.nafiz1001.waybar = {
    enable = lib.mkEnableOption "Waybar";
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };

    home.packages = with pkgs; [
      pavucontrol
    ];
  };
}
