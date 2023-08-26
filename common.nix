{ config, lib, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  nix.settings.auto-optimise-store = true;

  environment.systemPackages = with pkgs; [ ];
}
