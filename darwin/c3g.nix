{ config, pkgs, ... }: {
  # services.postgresql = rec {
  #   enable = true;
  #   dataDir = "/Users/nafizislam/var/lib/pgsql/data";
  #   initdbArgs = ["--pgdata=directory=${dataDir}"];
  #   authentication = ''
  #     # TYPE  DATABASE        USER            ADDRESS                 METHOD

  #     # "local" is for Unix domain socket connections only
  #     local   all             postgres                                trust
  #     local   all             admin                                   trust
  #     # IPv4 local connections:
  #     host    all             postgres        0.0.0.0/0               trust
  #     host    all             admin           0.0.0.0/0               md5
  #     # IPv6 local connections:
  #     host    all             all             0.0.0.0/0               ident
  #     # Allow replication connections from localhost, by a user with the
  #     # replication privilege.
  #     local   replication     all                                     peer
  #     host    replication     all             0.0.0.0/0               ident
  #     host    replication     all             0.0.0.0/0               ident
  #   '';

  #   ensureUsers = [
  #     {
  #       name = "postgres";
  #       ensurePermissions = {
  #         "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
  #       };
  #       ensureClauses = {
  #         superuser = true;
  #         createrole = true;
  #         createdb = true;
  #       };
  #     }
  #     {
  #       name = "admin";
  #       ensurePermissions = {
  #         "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
  #       };
  #       ensureClauses = { createdb = true; };
  #     }
  #   ];
  # };

  # launchd.user.agents.postgresql.serviceConfig = {
  #   StandardErrorPath = "/Users/nafizislam/postgres.error.log";
  #   StandardOutPath = "/Users/nafizislam/postgres.log";
  # };

  homebrew = {
    brews = [ "postgresql@14" ];
  };

  environment.systemPackages = with pkgs; [
    # c library
    stdenv.cc.cc.lib
    # openssl
    openssl

    # python
    (python311.withPackages (p: with p; [ pip virtualenv ]))
    libffi

    # node
    nodejs-18_x
    nodePackages.pyright
    nodePackages.npm
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.node-gyp-build
    nodePackages.node-pre-gyp # node
  ];
}
