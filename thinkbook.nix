inputs@{ nixpkgs, home-manager, nixos-hardware, ... }:
let
  username = "nafiz";
  homeDirectory = "/home/nafiz";
  mkNixosHomeModule = username: homeDirectory: {
    home-manager.users.${username} = {
      imports = [ ./home ];
      home = { inherit username homeDirectory; };
    };
  };
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

    { nafiz1001.gaming.enable = false; }
    ./nixos/gaming.nix

    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    }
    home-manager.nixosModules.home-manager

    (mkNixosHomeModule "root" "/root")
    (mkNixosHomeModule username homeDirectory)
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
}
