{ config, lib, pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    pavucontrol
    pamixer

    polkit-kde-agent
  ];
}
