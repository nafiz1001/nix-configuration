{ config, lib, inputs, pkgs, ... }:
let
  cfg = { inherit (config.nafiz1001) squeak-vm; };
  opensmalltalk-vm-pkgs =
    pkgs.callPackage (import ./opensmalltalk-vm-pkgs.nix) { };
in {
  options.nafiz1001.squeak-vm = { enable = lib.mkEnableOption "Squeak VM"; };

  config = lib.mkIf cfg.squeak-vm.enable {
    environment.systemPackages = [ opensmalltalk-vm-pkgs.squeak-cog-spur ];

    security.pam.loginLimits = [
      {
        domain = "*";
        type = "hard";
        item = "rtprio";
        value = "2";
      }
      {
        domain = "*";
        type = "soft";
        item = "rtprio";
        value = "2";
      }
    ];

    environment.sessionVariables = { SQUEAK_DISPLAY_PER_MONITOR_SCALE = "1"; };
  };
}
