{ config, pkgs, lib, ... }:
{
  imports = [
    ./neovim # TODO: apply module pattern
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # nixpkgs.config.allowUnfree = true;

  programs.ssh.enable = true;
  services.ssh-agent.enable = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.zsh = {
    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
    initExtra = lib.strings.concatStringsSep "\n" [
      ''bindkey "^R" history-incremental-pattern-search-backward''
      "bindkey -v"
    ];
  };

  programs.fish = {
    interactiveShellInit =
      lib.strings.concatStringsSep "\n" [ "fish_vi_key_bindings" ];
  };

  targets.genericLinux.enable = pkgs.stdenv.isLinux;

  programs.git = {
    enable = true;
    userName = "Nafiz Islam";
    userEmail = "nafiz.islam1001@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      url."https://".insteadOf = [ "git://" ];
      core.editor = "nvim";
    };
    lfs.enable = true;
  };

  programs.tmux = { extraConfig = ""; };

  home.sessionVariables = { FZF_DEFAULT_COMMAND = "rg --files --hidden"; };

  # generates user-dirs.dirs
  xdg.userDirs.enable = true;

  nixpkgs.overlays = [
    (self: super: {
      qbittorrent = super.qbittorrent.override { guiSupport = false; };
    })
  ];

  services.syncthing = { enable = pkgs.stdenv.isLinux; };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29;
    # extraPackages = epkgs: [ epkgs.vterm ];
  };
  services.emacs = {
    enable = false;
    package = pkgs.emacs29;
    # extraPackages = epkgs: [ epkgs.vterm ];
  };

  programs.tmux = {
    enable = true;
    mouse = true;
  };

  home.packages = with pkgs; [
    nixd
    nixfmt
    nix-index
    direnv

    neofetch

    jq
    fd
    fzf
    ripgrep
    # socat
    pandoc

    zip
    unzip

    htop

    bc

    # yt-dlp
    # rustup
    # gcc
  ];
}
