{ config, lib, pkgs, ... }: {
  services.xserver = {
    enable = true;

    libinput = {
      enable = true;
      # disabling mouse acceleration
      mouse = { accelProfile = "flat"; };
      # disabling touchpad acceleration
      touchpad = { accelProfile = "flat"; };
    };

    excludePackages = [ pkgs.xterm ];
  };

  environment.systemPackages = with pkgs; [
    xclip
  ];
}
