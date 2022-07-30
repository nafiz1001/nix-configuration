{ config, lib, pkgs, ... }:
{
  imports = [
    <home-manager/nixos>
  ];

  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  nix.settings.auto-optimise-store = true;

  programs.zsh.enable = true;
  programs.fish.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  environment.systemPackages = with pkgs; [ ];
}
