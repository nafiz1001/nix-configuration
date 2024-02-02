{
  description = "Nix configuration of nafiz1001";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager-darwin = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: Use opensmalltalk-vm from master after this merges:
    # https://github.com/NixOS/nixpkgs/pull/286421
    nixpkgs-opensmalltalk-vm-update.url = "github:jbaum98/nixpkgs/opensmalltalk-vm-update";
  };

  outputs = inputs@{ nixpkgs, home-manager, darwin, home-manager-darwin
    , nixos-hardware, ... }: {
      homeConfigurations.wsl = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./home.nix ];
      };
      nixosConfigurations.nixos = let
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
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.root = {
              imports = [ ./home ];
              home = {
                username = "root";
                homeDirectory = "/root";
              };
            };
            home-manager.users.${username} = {
              imports = [ ./home ];
              home = { inherit username homeDirectory; };
            };
          }

          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-cpu-intel-cpu-only
          nixos-hardware.nixosModules.common-gpu-intel
          nixos-hardware.nixosModules.common-pc
          nixos-hardware.nixosModules.common-pc-ssd
          nixos-hardware.nixosModules.common-pc-laptop
          nixos-hardware.nixosModules.common-pc-laptop-ssd
        ];
      };
      darwinConfigurations.orchid = let
        username = "nafizislam";
        homeDirectory = "/Users/nafizislam";
      in darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        specialArgs = {
          inherit inputs;
          inherit username homeDirectory;
        };
        modules = [
          ./darwin-configuration.nix
          home-manager-darwin.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = { imports = [ ./home ]; };
          }
          ./darwin/c3g.nix
        ];
      };
    };
}
