{ config, pkgs, lib, ... }:

let
  username = "nafiz";
  homeDirectory = "/home/${username}";
  startSSHAgent = ''
    if ! pgrep -u "$USER" ssh-agent > /dev/null; then
        ssh-agent -t 1h > "$HOME/.ssh/ssh-agent.env"
    fi
    if [[ ! "$SSH_AUTH_SOCK" ]]; then
        source "$HOME/.ssh/ssh-agent.env" >/dev/null
    fi
  '';
  doom-emacs = pkgs.callPackage (builtins.fetchTarball {
    url = https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz;
  }) {
    doomPrivateDir = /${homeDirectory}/.config/doom;
  };
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    inherit username homeDirectory;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.ssh.enable = true;

  programs.bash = {
    enable = true;
    bashrcExtra = startSSHAgent;
  };

  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;
    initExtra = startSSHAgent + ''
      bindkey "^R" history-incremental-pattern-search-backward
      '';
  };

  targets.genericLinux.enable = pkgs.stdenv.isLinux;
  
  programs.git = {
    enable = true;
    userName = "Nafiz Islam";
    userEmail = "nafiz.islam1001@gmail.com";
    extraConfig = {
      init.defaultBranch = "master";
      url."https://".insteadOf = [ "git://" ];
      core.editor = "nvim";
    };
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    extraConfig = ''
        set clipboard+=unnamedplus
        set mouse=a
	set number
    '';
    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-gitgutter
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

    zip

    tmux

    bc
    calc

    rsync

    doom-emacs
  ];
}
