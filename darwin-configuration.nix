{ config, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];

  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [ ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true;

  users.users.nislam = {
    name = "nislam";
    home = "/Users/nislam";
    shell = pkgs.fish;
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.nislam =
      let
        username = "nislam";
        homeDirectory = "/Users/nislam";
      in
      {
        imports = [ ./home ];
        home = {
          inherit username homeDirectory;
        };
        home.packages = with pkgs; [
          brew
        ];
      };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
