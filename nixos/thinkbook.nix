{ config, lib, pkgs, ... }: let
  useDHCP = !config.networking.networkmanager.enable;
in {
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
  boot.kernelPackages = pkgs.linuxPackages_6_8;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = { STOP_CHARGE_THRESH_BAT0 = "1"; };
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
  };
  boot.loader.efi = {
    efiSysMountPoint = "/boot";
  };

  fileSystems."/" = {
    device = "/dev/nvme0n1p2";
    fsType = "ext4";
  };

  swapDevices = [ ];

  networking.useDHCP = useDHCP;
  networking.interfaces.enp0s31f6.useDHCP = useDHCP;
  networking.interfaces.wlan0.useDHCP = useDHCP;

  networking.networkmanager.wifi.scanRandMacAddress = false;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  services.upower.enable = true;

  virtualisation.kvmgt.enable = true;
}
