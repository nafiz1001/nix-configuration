{ config, lib, pkgs, modulesPath, username, homeDirectory, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # TODO: use nix module pattern instead
    ./xserver.nix
    # ./hyprland.nix
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "sdhci_pci"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.kernelPackages = pkgs.linuxPackages_6_1;

  hardware.opengl.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  services.tlp = { settings = { STOP_CHARGE_THRESH_BAT0 = "1"; }; };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/nvme0n1p2";
    fsType = "ext4";
  };

  boot.tmp = {
    cleanOnBoot = true;
    useTmpfs = true;
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22000 # TODO: syncthing (use module pattern)
    ];
    allowedTCPPortRanges = [
      # { from = 1714; to = 1764; } # TODO: kde-connect (already done)
    ];
    allowedUDPPorts = [
      22000 # TODO: syncthing (use module pattern)
      21027 # TODO: syncthing (use module pattern)
    ];
    allowedUDPPortRanges = [
      # { from = 1714; to = 1764; } # TODO: kde-connect (already done)
    ];
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };
  boot.loader.systemd-boot.enable = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.scanRandMacAddress = false;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  # Set your time zone.
  time.timeZone = "America/New_York";

  console = {
    font = "ter-i32b";
    packages = with pkgs; [ terminus_font ];
    earlySetup = true;
  };

  services.upower.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
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
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    name = username;
    home = homeDirectory;
    shell = pkgs.bash;
  };

  programs.dconf.enable = true;
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  services.gnome.gnome-keyring.enable = true;
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    # gtk portal needed to make gtk apps happy
    # extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  # services.geoclue2 = {
  #   enable = true;
  # };

  services.flatpak.enable = true;

  programs.kdeconnect.enable = true;

  environment.systemPackages = with pkgs; [
    pavucontrol
    pamixer

    firefox

    vscode

    # discord (flatpak)
    slack
    zoom-us

    okular
    mpv

    obs-studio
    gimp
    libreoffice
    # dropbox
    # obsidian
    audacity

    xwaylandvideobridge

    gamescope
    # lutris (flatpak)
  ];

  # programs.steam.enable = true; (flatpak)
  programs.gamemode.enable = true;

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
