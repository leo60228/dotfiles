let
  lib = import ../lib;
in
lib.makeComponent "postgres" (
  {
    cfg,
    config,
    pkgs,
    lib,
    ...
  }:
  with lib;
  {
    opts = {
      package = mkOption {
        type = types.package;
        default = pkgs.postgresql_16;
      };
      newPackage = mkOption {
        type = types.package;
        default = pkgs.postgresql_16;
      };
    };

    config = {
      services.postgresql = {
        inherit (cfg) package;

        enable = true;
        ensureUsers = [
          {
            name = "leo60228";
            ensureDBOwnership = true;
          }
        ];
        ensureDatabases = [ "leo60228" ];
      };

      environment.systemPackages =
        let
          newPostgres = cfg.newPackage;
        in
        [
          (pkgs.writeScriptBin "upgrade-pg-cluster" ''
            set -eux
            # XXX it's perhaps advisable to stop all services that depend on postgresql
            systemctl stop postgresql

            export NEWDATA="/var/lib/postgresql/${newPostgres.psqlSchema}"

            export NEWBIN="${newPostgres}/bin"

            export OLDDATA="${config.services.postgresql.dataDir}"
            export OLDBIN="${config.services.postgresql.package}/bin"

            install -d -m 0700 -o postgres -g postgres "$NEWDATA"
            cd "$NEWDATA"
            sudo -u postgres $NEWBIN/initdb -D "$NEWDATA"

            sudo -u postgres $NEWBIN/pg_upgrade \
              --old-datadir "$OLDDATA" --new-datadir "$NEWDATA" \
              --old-bindir $OLDBIN --new-bindir $NEWBIN \
              "$@"
          '')
        ];
    };
  }
)
