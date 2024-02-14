{ config, pkgs, lib, osConfig, ... }:
{
  imports = [
    ./neovim
    ./emacs
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

  programs.ssh.enable = true;
  services.ssh-agent.enable = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.zsh = {
    enable = lib.mkDefault false;
    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
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
  programs.vscode.enable = false; # use flatpak

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

    # bc

    yt-dlp

    rustup
    gdb
    lldb

    appimage-run
  ];

  # home.file.".steam/steam/steam_dev.cfg".text = lib.mkIf osConfig.programs.steam.enable
  #   ''
  #   @nClientDownloadEnableHTTP2PlatformLinux 0
  #   @fDownloadRateImprovementToAddAnotherConnection 1.0
  #   '';
}
