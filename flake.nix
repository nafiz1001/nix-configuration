{
  description = "Nix configuration of nafiz1001";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager-darwin = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: Use opensmalltalk-vm from NixOS/nixpkgs after
    # this merges: https://github.com/NixOS/nixpkgs/pull/286421
    nixpkgs-opensmalltalk-vm-update.url = "github:jbaum98/nixpkgs/opensmalltalk-vm-update";
  };

  outputs = inputs@{ nixpkgs, home-manager, darwin, home-manager-darwin , nixos-hardware, ... }:
    {
      homeConfigurations.wsl = (import ./wsl.nix) inputs;
      nixosConfigurations.thinkbook = (import ./thinkbook.nix) inputs;
      darwinConfigurations.orchid = (import ./orchid.nix) inputs;
    };
}
