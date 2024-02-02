{ config, lib, pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    kitty

    pavucontrol
    pamixer

    polkit-kde-agent

    gwenview
    mpv
  ];
}
