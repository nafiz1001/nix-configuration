{ config, lib, pkgs, inputs, ... }:

{
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

  nixpkgs.overlays =
    [ (self: super: { eww = super.eww.override { withWayland = true; }; }) ];

  environment.systemPackages = with pkgs; [
    wl-clipboard
    fuzzel
    dunst
    gammastep
    polkit-kde-agent
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    waybar
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast

    gwenview
  ];
}
