{ config, lib, pkgs, ... }: {
  imports = [
    # ./openbox.nix
    # ./kde.nix
    ./gnome.nix
  ];
  
  services.xserver.enable = true;
  services.xserver = {
    libinput = {
      enable = true;

      # disabling mouse acceleration
      mouse = { accelProfile = "flat"; };

      # disabling touchpad acceleration
      touchpad = { accelProfile = "flat"; };
    };
  };

  services.xserver = { excludePackages = [ pkgs.xterm ]; };
  environment.systemPackages = with pkgs; [
    xclip
    wl-clipboard
  ];
}
