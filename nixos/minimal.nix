{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.nafiz1001.minimal;
in
{
  options.nafiz1001.minimal = {
    enable = lib.mkEnableOption "Minimal Desktop Apps";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pavucontrol
      pamixer

      kitty
      gwenview
      mpv
      xfce.thunar

      polkit-kde-agent

      gammastep
    ];
  };
}
