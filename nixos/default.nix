{ config, lib, pkgs, modulesPath, ... }:
let
  username = "nafiz";
  homeDirectory = "/home/nafiz";
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    <home-manager/nixos>
    ./xserver.nix
    ./gnome.nix
    # ./plasma.nix
    ./apps.nix
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" ];
  boot.initrd.kernelModules = [ "wl" ];
  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3bf50b22-3a0e-400f-a2e3-9a063b767880";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/775F-3C0E";
    fsType = "vfat";
  };

  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/mnt/c" = {
    device = "/dev/sda3";
    fsType = "ntfs";
    options = [ "rw" ];
  };

  boot.cleanTmpDir = true;

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

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

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  nixpkgs.overlays = [
    (self: super: {
      discord = super.discord.override {
        nss = pkgs.nss_latest;
      };
    })
  ];


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    name = username;
    home = homeDirectory;
    shell = pkgs.fish;
  };
  home-manager = {
    users.root = {
      imports = [ ../home ];
      home = {
        username = "root";
        homeDirectory = "/root";
      };
    };
    users.${username} = {
      imports = [ ../home ];
      home = {
        inherit username homeDirectory;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    firefox
    brave

    discord
    slack
    zoom-us
    fractal

    dropbox
    qbittorrent

    vscode

    okular

    kolourpaint
  ];

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
