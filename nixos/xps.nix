{ config, lib, pkgs, ... }:
let useDHCP = !config.networking.networkmanager.enable;
in {
  system.stateVersion = "24.05";

  boot.kernelPackages = pkgs.linuxPackages_6_10;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
  };
  boot.loader.efi = { efiSysMountPoint = "/boot"; };

  fileSystems."/" = {
    device = "/dev/nvme0n1p2";
    fsType = "ext4";
  };

  swapDevices = [ ];

  networking.useDHCP = useDHCP;
  networking.interfaces.wlp0s20f3.useDHCP = useDHCP;

  networking.networkmanager.wifi.scanRandMacAddress = false;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  services.upower.enable = true;

  virtualisation.kvmgt.enable = false; # not supported on 13th gen

  services.fwupd.enable = true;
}
