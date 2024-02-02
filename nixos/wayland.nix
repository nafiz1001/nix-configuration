{ config, lib, pkgs, inputs, ... }: {
  nixpkgs.overlays =
    [ (self: super: { eww = super.eww.override { withWayland = true; }; }) ];

  environment.systemPackages = with pkgs; [
    wl-clipboard
    xwaylandvideobridge # screensharing
    obs-studio # screensharing

    libsForQt5.qt5.qtwayland
    qt6.qtwayland
  ];
}
