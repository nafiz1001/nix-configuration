{ config, lib, pkgs, ... }:

{
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.enable = true;

  environment.systemPackages = with pkgs; [
    ark
    kate
    galculator
    kcalc
  ];
}
