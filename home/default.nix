{ config, pkgs, lib, ... }:
let
  startSSHAgent = ''
    if ! pgrep -u "$USER" ssh-agent > /dev/null; then
        ssh-agent -t 1h > "$HOME/.ssh/ssh-agent.env"
    fi
    if [[ ! "$SSH_AUTH_SOCK" ]]; then
        source "$HOME/.ssh/ssh-agent.env" >/dev/null
    fi
  '';
  # tex = (pkgs.texlive.combine {
  #   inherit (pkgs.texlive) scheme-full;
  # });
in
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
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.ssh.enable = true;

  programs.bash = {
    enable = true;
    bashrcExtra = lib.strings.concatStringsSep "\n" [
      startSSHAgent
    ];
  };

  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;
    initExtra = lib.strings.concatStringsSep "\n" [
      startSSHAgent
      ''bindkey "^R" history-incremental-pattern-search-backward''
      "bindkey -v"
    ];
  };

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "fish-ssh-agent";
        src = pkgs.fetchFromGitHub {
          owner = "danhper";
          repo = "fish-ssh-agent";
          rev = "fd70a2afdd03caf9bf609746bf6b993b9e83be57";
          sha256 = "e94Sd1GSUAxwLVVo5yR6msq0jZLOn2m+JZJ6mvwQdLs=";
        };
      }
    ];
    interactiveShellInit = lib.strings.concatStringsSep "\n" [
      "fish_vi_key_bindings"
    ];
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

  programs.tmux = {
    extraConfig = "";
  };

  home.sessionVariables = {
    FZF_DEFAULT_COMMAND = "rg --files --hidden";
  };

  home.packages = with pkgs; [
    nixpkgs-fmt
    nix-index

    fd
    fzf
    ripgrep
    pdfgrep
    tree

    zip

    tmux
    htop

    direnv

    bc
    calc
    octave
    gnuplot

    dropbox
    onedrive
    rclone
    qbittorrent
    rsync
    youtube-dl

    # tex
    pandoc

    # plan9port
  ];
}
