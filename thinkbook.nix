inputs@{ nixpkgs, home-manager, nixos-hardware, nixpkgs-unstable, ... }:
let
  username = "nafiz";
  homeDirectory = "/home/nafiz";
  mkNixosHomeModule = username: homeDirectory: {
    home-manager.users.${username} = {
      imports = [ ./home ];
      home = { inherit username homeDirectory; };
    };
  };
  system = "x86_64-linux";
  # https://www.reddit.com/r/NixOS/comments/1c6m5j4/comment/l02sj4u/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
  pkgs-unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = {
    inputs = { inherit (inputs) nixpkgs; };
    inherit pkgs-unstable;
    inherit username homeDirectory;
  };
  modules = [
    ./common.nix
    ./nixos
    ./nixos/thinkbook.nix

    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit pkgs-unstable; };
    }
    home-manager.nixosModules.home-manager

    (mkNixosHomeModule "root" "/root")
    (mkNixosHomeModule username homeDirectory)
  ] ++ (with nixos-hardware.nixosModules; [
    common-cpu-intel
    common-pc-laptop
    common-pc-laptop-ssd
  ]);
}
