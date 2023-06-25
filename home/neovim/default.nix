{ config, pkgs, lib, ... }: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    plugins = with pkgs.vimPlugins; [ ];
  };

  home.sessionVariables = {
    EDITOR = "neovim";
    VISUAL = "neovim";
  };

  home.packages = with pkgs; [ ];
}
