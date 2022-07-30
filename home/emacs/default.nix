{ config, pkgs, lib, ... }:
{
  services.emacs = {
    enable = false;
  };
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [
      # auctex
      company
      consult
      embark
      embark-consult
      envrc
      evil
      evil-collection
      evil-commentary
      flycheck
      git-gutter
      helpful
      hl-todo
      lsp-mode
      lsp-ui
      lsp-pyright
      magit
      marginalia
      nix-mode
      no-littering
      nyan-mode
      orderless
      projectile
      rainbow-delimiters
      setup
      smartparens
      tree-sitter
      tree-sitter-langs
      undo-tree
      vertico
      # vlf
      vterm
      yasnippet
    ];
  };

  home.file.".emacs".source = ./lisp/init.el;

  home.sessionVariables = { };

  home.packages = with pkgs; [ ];
}
