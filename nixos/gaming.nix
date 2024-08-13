{ config, lib, pkgs, ... }: {
  imports = [ ];
  nixpkgs.config.allowUnfree = true;
  programs.steam.enable = true;
}
