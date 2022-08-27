{
  description = "Nix configuration of nafiz1001";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, darwin, ... }:
    {
      homeConfigurations.nafiz = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./home.nix ];
      };
      nixosConfigurations.nafiz = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs // {
          home-manager = home-manager.nixosModules.home-manager;
        };
        modules = [ ./configuration.nix ];
      };
      darwinConfigurations.nislam = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        inputs = inputs // {
          home-manager = home-manager.darwinModules.home-manager;
        };
        modules = [ ./darwin-configuration.nix ];
      };
    };
}
