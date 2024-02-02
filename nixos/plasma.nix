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
    services.xserver.desktopManager.plasma5 = true;
  };
}
