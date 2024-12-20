{
  description = "Nix configuration of nafiz1001";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs: {
    homeConfigurations.wsl = (import ./wsl.nix) inputs;
    nixosConfigurations.xps = (import ./xps.nix) inputs;
  };
}
