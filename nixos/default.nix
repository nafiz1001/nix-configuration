{ config, lib, pkgs, modulesPath, username, homeDirectory, pkgs-unstable, ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./gnome.nix
    ./plasma.nix
    ./openbox.nix
    ./sway.nix
    ./qemu.nix
    ./opensmalltalk-vm
  ];

  boot.kernel.sysctl."kernel.sysrq" = 1;
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

  hardware.opengl.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot.tmp = {
    cleanOnBoot = true;
    useTmpfs = true;
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22000 # NOTE: home-manager's syncthing does not set firewall
    ];
    allowedTCPPortRanges = [
      # { from = 1714; to = 1764; } # kdeconnect (NOTE: already done)
    ];
    allowedUDPPorts = [
      22000 # NOTE: home-manager's syncthing does not set firewall
      21027 # NOTE: home-manager's syncthing does not set firewall
    ];
    allowedUDPPortRanges = [
      # { from = 1714; to = 1764; } # kdeconnect (NOTE: already done)
    ];
  };

  boot.loader.efi = { canTouchEfiVariables = true; };
  boot.loader.systemd-boot.enable = true;

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  console = {
    font = "ter-i32b";
    packages = with pkgs; [ terminus_font ];
    earlySetup = true;
  };

  virtualisation = {
    docker.rootless = {
      enable = false;
      setSocketVariable = true;
    };
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  services.libinput = {
    enable = true;
    # disabling mouse acceleration
    mouse = { accelProfile = "flat"; };
    # disabling touchpad acceleration
    touchpad = { accelProfile = "flat"; };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
  hardware.pulseaudio.enable = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      # "kvm" # not supported on 12th gen
    ];
    name = username;
    home = homeDirectory;
    shell = pkgs.bash;
  };

  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  services.dbus.enable = true;
  xdg.portal.enable = true;
  # services.geoclue2 = {
  #   enable = true;
  # };
  security.polkit.enable = true;

  services.flatpak.enable = true;

  programs.kdeconnect.enable = true;
  programs.firefox = {
    enable = true;
    # package = pkgs-unstable.firefox;
  };

  environment.systemPackages = (with pkgs; [
    psmisc # e.g. fuser
    okular
    libreoffice-fresh

    # discord # krisp missing, use flatpak
    slack
    zoom-us
    thunderbird

    # dropbox # I use syncthing
    qbittorrent

    # obsidian # I use org-mode

    gimp
    audacity
    # kdenlive # glaxnimate missing, use flatpak
    obs-studio

    # distrobox # does not work well in NixOS

    wireshark

    gnome.gnome-chess
    stockfish
    gnome.gnome-sudoku
    libremines
  ]) ++ (with pkgs-unstable;
    [
      # zoom-us # broken
    ]);

  environment.sessionVariables = rec { PATH = [ "$HOME/.local/bin" ]; };

  nafiz1001.gnome.enable = true;
  nafiz1001.openbox.enable = false;
  nafiz1001.plasma.enable = false;
  nafiz1001.sway.enable = false;

  nafiz1001.qemu.enable = true;
  nafiz1001.squeak-vm.enable = false;
}
