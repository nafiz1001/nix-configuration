{ config, pkgs, lib, ... }:

let
  username = "nafiz";
  homeDirectory = "/home/${username}";
in {
  imports = [ ./home ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = { inherit username homeDirectory; };
}
