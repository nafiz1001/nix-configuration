{ config, lib, pkgs, ... }:
let
  cfg = config.nafiz1001.plasma;
in
{
  imports = [ ./xserver.nix ./wayland.nix ];

  options.nafiz1001.plasma = {
    enable = lib.mkEnableOption "Plasma";
  };

  config = lib.mkIf cfg.enable {
    nafiz1001.xserver.enable = true;
    nafiz1001.wayland.enable = true;

    services.xserver.desktopManager.plasma5.enable = true;
  };
}
