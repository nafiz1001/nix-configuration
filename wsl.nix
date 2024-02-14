inputs@{ nixpkgs, home-manager, ... }:
let
  username = "nafiz";
  homeDirectory = "/home/nafiz";
in home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.x86_64-linux;
  modules = [
    ./home
    { home = { inherit username homeDirectory; }; }
  ];
};
