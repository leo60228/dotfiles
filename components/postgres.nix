let lib = import ../lib; in
lib.makeComponent "postgres"
({cfg, config, pkgs, lib, ...}: with lib; {
  opts = {
    package = mkOption {
      type = types.package;
      default = pkgs.postgresql_12;
    };
    newPackage = mkOption {
      type = types.package;
      default = pkgs.postgresql_12;
    };
  };

  config = {
    services.postgresql = {
      inherit (cfg) package;

      enable = true;
      ensureUsers = [ {
        name = "leo60228";
        ensurePermissions = {
          "DATABASE datablase" = "ALL PRIVILEGES";
          "DATABASE fluthlu" = "ALL PRIVILEGES";
          "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
        };
      } ];
      ensureDatabases = [ "datablase" "fluthlu" ];
    };

    containers.temp-pg.config.system.stateVersion = "22.11";
    containers.temp-pg.config.services.postgresql = {
      enable = true;
      package = cfg.newPackage;
      dataDir = "/var/lib/new_postgresql";
    };
    environment.systemPackages =
      let newpg = config.containers.temp-pg.config.services.postgresql;
      in [
        (pkgs.writeScriptBin "upgrade-pg-cluster" ''
          set -x
          export OLDDATA="${config.services.postgresql.dataDir}"
          export NEWDATA="${newpg.dataDir}"
          export OLDBIN="${config.services.postgresql.package}/bin"
          export NEWBIN="${newpg.package}/bin"

          install -d -m 0700 -o postgres -g postgres "$NEWDATA"
          cd "$NEWDATA"
          sudo -u postgres $NEWBIN/initdb -D "$NEWDATA"

          systemctl stop postgresql    # old one

          sudo -u postgres $NEWBIN/pg_upgrade \
            --old-datadir "$OLDDATA" --new-datadir "$NEWDATA" \
            --old-bindir $OLDBIN --new-bindir $NEWBIN \
            "$@"
        '')
      ];
  };
})
