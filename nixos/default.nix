{ config, lib, pkgs, modulesPath, username, homeDirectory, pkgs-unstable, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./qemu.nix
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
      22000 # syncthing
    ];
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # kdeconnect
    ];
    allowedUDPPorts = [
      22000 # syncthing
      21027 # syncthing
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # kdeconnect
    ];
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
  };
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
    extraGroups = [ "wheel" "networkmanager" "video" ]; # Enable ‘sudo’ for the user.
    name = username;
    home = homeDirectory;
    shell = pkgs.bash;
  };

  programs.dconf.enable = true;
  services.dbus.enable = true;
  security.polkit.enable = true;

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  environment.systemPackages = (with pkgs; [
    # okular
    libreoffice-fresh

    # discord # flatpak
    slack
    zoom
    thunderbird

    # dropbox # I use syncthing
    qbittorrent

    # obsidian # I use org-mode

    gimp
    # audacity
    # libsForQt5.kdenlive # flatpak
    # obs-studio

    # distrobox # does not work well in NixOS

    wireshark

    obs-studio
  ]) ++ (with pkgs-unstable; [
    # zoom-us # broken
  ]);

  environment.sessionVariables = rec {
    PATH = [
      "$HOME/.local/bin"
    ];
  };

  # https://nixos.wiki/wiki/Sway#Brightness_and_volume
  programs.light.enable = true;

  nixpkgs.overlays =
    [ (self: super: { eww = super.eww.override { withWayland = true; }; }) ];

  # https://github.com/nix-community/home-manager/blob/master/modules/misc/xdg-portal.nix#L26C9-L27C1
  environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];

  nafiz1001.qemu.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
