{ config, pkgs, lib, ... }:
let
  cfg = config.nafiz1001.c3g;
in
{
  options.nafiz1001.c3g = {
    enable = lib.mkEnableOption "C3G Project Dependencies";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # c library
      stdenv.cc.cc.lib
      # openssl
      openssl

      # python
      (python311.withPackages (p: with p; [ pip virtualenv ]))
      libffi
      nodePackages.pyright

      # node
      # nodejs_18
      nodePackages.npm
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.node-gyp-build
      nodePackages.node-pre-gyp

      # database
      postgresql
    ];
  };
}
