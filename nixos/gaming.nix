{ config, lib, pkgs, ... }:
let
  cfg = config.nafiz1001.gaming;
in
{
  imports = [ ];

  options.nafiz1001.gaming = {
    enable = lib.mkEnableOption "Gaming";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # lutris
    ];

    programs.steam.enable = true;

    programs.gamescope.enable = true;
    programs.steam.gamescopeSession = {
      enable = false;
      args = [ ];
      env = { };
    };

    programs.gamemode.enable = true;
  };
}
