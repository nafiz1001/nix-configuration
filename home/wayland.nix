{ config, pkgs, lib, osConfig, ... }:
let
  cfg = config.nafiz1001.wayland;
in
{
  options.nafiz1001.wayland = {
    enable = lib.mkEnableOption "Wayland";
  };

  config = lib.mkIf cfg.enable {    
    home.packages = with pkgs; [
      wl-clipboard

      libsForQt5.qt5.qtwayland
      qt6.qtwayland
    ];
  };
}
