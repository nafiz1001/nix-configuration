{ config, pkgs, pkgs-unstable, lib, osConfig, ... }: {
  imports = [ ./neovim ./emacs ];

  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.ssh = {
    enable = true;
    # https://github.com/nix-community/home-manager/issues/4134
    includes = [ "myconfig" ];
    extraConfig = ''
      IdentitiesOnly yes
    '';
  };
  services.ssh-agent.enable = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.zsh = {
    enable = lib.mkDefault false;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    initExtra = lib.strings.concatStringsSep "\n" [
      ''bindkey "^R" history-incremental-pattern-search-backward''
      "bindkey -v"
    ];
  };

  programs.fish = {
    enable = lib.mkDefault false;
    interactiveShellInit =
      lib.strings.concatStringsSep "\n" [ "fish_vi_key_bindings" ];
  };

  targets.genericLinux.enable = pkgs.stdenv.isLinux;

  nafiz1001.neovim.enable = true;
  nafiz1001.emacs.enable = pkgs.stdenv.isLinux;
  programs.vscode = {
    enable = pkgs.stdenv.isLinux;
    package = pkgs-unstable.vscode;
  };

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

  # home.sessionVariables = { FZF_DEFAULT_COMMAND = "rg --files --hidden"; };

  # generates user-dirs.dirs
  xdg.userDirs.enable = pkgs.stdenv.isLinux;

  services.syncthing = { enable = pkgs.stdenv.isLinux; };

  programs.tmux = {
    enable = true;
    mouse = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # crashes my computer
  programs.nix-index.enable = false;

  home.packages = with pkgs; [
    nixd
    nixfmt

    # neofetch
    fastfetch

    jq
    fd
    fzf
    ripgrep
    # socat
    pandoc
    tree
    pv

    zip
    unzip

    htop

    # bc

    yt-dlp
    wget

    rustup
    gdb
    lldb
    gnumake

    appimage-run

    sshfs
  ];

  # home.file.".steam/steam/steam_dev.cfg".text = lib.mkIf osConfig.programs.steam.enable
  #   ''
  #   @nClientDownloadEnableHTTP2PlatformLinux 0
  #   @fDownloadRateImprovementToAddAnotherConnection 1.0
  #   '';
}
