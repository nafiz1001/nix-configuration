{ config, pkgs, lib, osConfig, ... }:
let
  cfg = config.nafiz1001.emacs;
  package = pkgs.emacs29;
  extraPackages = epkgs: [
    epkgs.treesit-grammars.with-all-grammars
  ];
  usingDisplayManager = (with osConfig.services.xserver.displayManager;
    gdm.enable || sddm.enable || lightdm.enable
  );
in
{
  options.nafiz1001.emacs = {
    enable = lib.mkEnableOption "Emacs";
  };

  config = lib.mkIf cfg.enable {
    programs.emacs = {
      enable = true;
      inherit package extraPackages;
    };
    services.emacs = {
      enable = true;
      defaultEditor = true;
      startWithUserSession =
        if usingDisplayManager
        then "graphical"
        else true;
    };

    home.packages = with pkgs; [ ];
  };
}
