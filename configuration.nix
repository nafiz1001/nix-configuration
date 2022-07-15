{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "monthly";
    };
  };

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  boot.loader.grub = {
    enable = true;
    version = 2;
    devices = [ "nodev" ];
    efiSupport = true;
    useOSProber = true;
  };

  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/mnt/c" =
  { device = "/dev/sda3";
    fsType = "ntfs";
    options = [ "rw" ];
  };

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.scanRandMacAddress = false;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  # Set your time zone.
  time.timeZone = "America/New_York";

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver = {
    libinput = {
      enable = true;

      # disabling mouse acceleration
      mouse = {
        accelProfile = "flat";
      };

      # disabling touchpad acceleration
      touchpad = {
        accelProfile = "flat";
      };
    };
  };
  services.xserver = {
    excludePackages = [ pkgs.xterm ];
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.autorun = true;

  # services.xserver.windowManager.i3 = {
  #   enable = true;
  #   extraPackages = with pkgs; [
  #     i3status
  #     i3blocks
  #   ];
  # };

  # location.provider = "geoclue2";
  # services.redshift = {
  #   enable = true;
  #   temperature = {
  #     day = 5500;
  #     night = 2500;
  #   };
  # };


  # services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.displayManager.sddm.enable = true;

  programs.dconf.enable = true;
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome = {
    enable = true;
  };
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome.epiphany
  ];

  services.gnome.gnome-keyring.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nafiz = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };
  home-manager.users.nafiz = import ./home.nix;
  fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    xclip
    firefox

    discord
    slack
    zoom-us

    dropbox
    qbittorrent

    vscode

    gnome.gnome-tweaks
    gnome.adwaita-icon-theme
    gnomeExtensions.appindicator

    # ark
    # kate
    # galculator
    # kolourpaint

    dmenu
  ];

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
