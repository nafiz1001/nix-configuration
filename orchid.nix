inputs@{ darwin, home-manager-darwin, ... }:
let
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

    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} = { imports = [ ./home ]; };
    }
    home-manager-darwin.darwinModules.home-manager

    ./darwin/c3g.nix
  ];
};
