{ config, pkgs, lib, ... }:
let
  cfg = config.nafiz1001.neovim;
in
{
  options.nafiz1001.neovim = {
    enable = lib.mkEnableOption "Neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      vimAlias = true;
      viAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      plugins = with pkgs.vimPlugins; [ ];
      extraConfig = builtins.readFile ./vimrc/default.vim;
    };

    home.packages = with pkgs; [ ];
  };
}
