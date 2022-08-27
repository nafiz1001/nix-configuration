{ config, lib, pkgs, home-manager, ... }:
{
  imports = [
    home-manager
  ];

  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixVersions.stable;
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
