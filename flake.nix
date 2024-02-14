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
    let
      mkNixosHomeModule = username: homeDirectory: {
        home-manager.users.${username} = {
          imports = [ ./home ];
          home = { inherit username homeDirectory; };
        };
      };
    in {
      homeConfigurations.wsl = let
        username = "nafiz";
        homeDirectory = "/home/nafiz";
      in home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./home
          { home = { inherit username homeDirectory; }; }
        ];
      };

      nixosConfigurations.thinkbook = let
        username = "nafiz";
        homeDirectory = "/home/nafiz";
      in nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inputs = {
            inherit (inputs) nixpkgs hyprland hyprland-contrib nixpkgs-opensmalltalk-vm-update;
          };
          inherit username homeDirectory;
        };
        modules = [
          ./common.nix
          ./nixos
          ./nixos/thinkbook.nix
          ./nixos/gaming.nix { nafiz1001.gaming.enable = true; }
          home-manager.nixosModules.home-manager
          # BIG FAT NOTE: this is not an argument!
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          {
            home-manager.users.${username} = {
              imports = [ ./home ];
              home = { inherit username homeDirectory; };
            };
          }
          {
            home-manager.users.root = {
              imports = [ ./home ];
              home = { username = "root"; homeDirectory = "/root"; };
            };
          }
        ]
        ++ (with nixos-hardware.nixosModules; [
          common-cpu-intel
          common-cpu-intel-cpu-only
          common-gpu-intel
          common-pc
          common-pc-ssd
          common-pc-laptop
          common-pc-laptop-ssd
        ]);
      };

      darwinConfigurations.orchid = let
        username = "nafizislam";
        homeDirectory = "/Users/nafizislam";
      in darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        specialArgs = {
          inputs = {
            inherit (inputs) darwin;
          };
          inherit username homeDirectory;
        };
        modules = [
          ./common.nix
          ./darwin
          home-manager-darwin.darwinModules.home-manager
          # BIG FAT NOTE: this is not an argument!
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} =
              { imports = [ ./home ]; };
          }
        ];
      };
    };
}
