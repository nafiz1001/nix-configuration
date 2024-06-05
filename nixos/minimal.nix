{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.nafiz1001.minimal;
in
{
  options.nafiz1001.minimal = {
    enable = lib.mkEnableOption "Minimal Desktop Apps";
  };

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      # extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      # config.common.default = "gtk";
    };

    services.displayManager.sddm.enable = true;
    
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
