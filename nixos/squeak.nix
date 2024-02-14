{ config, lib, inputs, ... }:
let
  cfg = config.nafiz1001.squeak;
  pkgs = inputs.nixpkgs-opensmalltalk-vm-update.legacyPackages.x86_64-linux;
in
{
  options.nafiz1001.squeak = {
    enable = lib.mkEnableOption "Squeak VM";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      opensmalltalk-vm.squeak-cog-spur
    ];

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

    environment.sessionVariables = {
      SQUEAK_DISPLAY_PER_MONITOR_SCALE = "1";
    };
  };
}
