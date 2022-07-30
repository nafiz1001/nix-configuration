{ config, pkgs, lib, ... }:
let
  default = builtins.readFile ./vimrc/default.vim;
  plugins = builtins.readFile ./vimrc/plugins.vim;
in
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    extraConfig = ''
      ${default}
      ${plugins}
    '';
    plugins = with pkgs.vimPlugins; [
      vim-commentary
      vim-nix
      vim-gitgutter
      (nvim-treesitter.withPlugins (p: builtins.attrValues p))

      vim-automkdir # automatically creating missing dirs on save
      vim-matchup
      nerdtree
      nerdtree-git-plugin
      vim-surround
      vim-polyglot
      vim-closetag
      # vim-indent-guides
      rainbow
      # vim-devicons
      # nvim-web-devicons

      plenary-nvim
      telescope-nvim
      telescope-fzf-native-nvim
    ];
  };

  home.sessionVariables = {
    EDITOR = "neovim";
    VISUAL = "neovim";
  };


  home.packages = with pkgs; [
    fd
    fzf
    ripgrep
  ];
}
