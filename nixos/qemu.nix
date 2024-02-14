{ config, lib, pkgs, ... }:
let
  cfg = config.nafiz1001.qemu;
in
{
  options.nafiz1001.qemu = {
    enable = lib.mkEnableOption "QEMU";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    virtualisation.libvirtd.qemu.ovmf.enable = true;
    virtualisation.libvirtd.qemu.runAsRoot = false;

    programs.virt-manager.enable = true;
    programs.dconf.enable = true;

    environment.systemPackages = with pkgs; [
      guestfs-tools
      virt-top
    ];
  };
}
