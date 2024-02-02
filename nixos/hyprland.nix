{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.nafiz1001.hyprland;
in
{
  imports = [ ./wayland.nix ./minimal.nix ];

  options.nafiz1001.hyprland = {
    enable = lib.mkEnableOption "Hyprland";
  };

  config = lib.mkIf cfg.enable {
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys =
        [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
    # programs.waybar.enable = true;

    xdg.portal = {
      wlr.enable = true; # false if using hyprland's xdg
      # extraPortals = [ pkgs.xdg-desktop-portal-hyprland ]; # TODO: fix existing link problem
    };

    environment.systemPackages = with pkgs; [
      fuzzel
      dunst
      gammastep
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
      waybar
    ];
  };
}
