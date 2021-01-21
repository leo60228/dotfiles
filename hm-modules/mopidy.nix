{ config, lib, pkgs, ... }:

with pkgs;
with lib;

let
  cfg = config.services.mopidy;

  mopidyConf = writeText "mopidy.conf" cfg.configuration;

  mopidyEnv = buildEnv {
    name = "mopidy-with-extensions-${mopidy.version}";
    paths = closePropagation cfg.extensionPackages;
    pathsToLink = [ "/${mopidyPackages.python.sitePackages}" ];
    buildInputs = [ makeWrapper ];
    postBuild = ''
      makeWrapper ${mopidy}/bin/mopidy $out/bin/mopidy \
        --prefix PYTHONPATH : $out/${mopidyPackages.python.sitePackages}
    '';
  };
in {

  options = {

    services.mopidy = {

      enable = mkEnableOption "Mopidy, a music player daemon";

      dataDir = mkOption {
        default = "${config.xdg.dataHome}/mopidy";
        type = types.str;
        description = ''
          The directory where Mopidy stores its state.
        '';
      };

      extensionPackages = mkOption {
        default = [];
        type = types.listOf types.package;
        example = literalExample "[ pkgs.mopidy-spotify ]";
        description = ''
          Mopidy extensions that should be loaded by the service.
        '';
      };

      configuration = mkOption {
        default = "";
        type = types.lines;
        description = ''
          The configuration that Mopidy should use.
        '';
      };

      extraConfigFiles = mkOption {
        default = [];
        type = types.listOf types.str;
        description = ''
          Extra config file read by Mopidy when the service starts.
          Later files in the list overrides earlier configuration.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    systemd.user.services.mopidy = {
      Install = {
        WantedBy = [ "default.target" ];
      };

      Unit = {
        After = [ "network.target" "sound.target" ];
        Description = "mopidy music player daemon";
      };

      Service = {
        ExecStartPre = "${coreutils}/bin/mkdir -p '${cfg.dataDir}'";
        ExecStart = "${mopidyEnv}/bin/mopidy --config ${concatStringsSep ":" ([mopidyConf] ++ cfg.extraConfigFiles)}";
      };
    };

    systemd.user.services.mopidy-scan = {
      Unit = {
        Description = "mopidy local files scanner";
      };

      Service = {
        ExecStartPre = "${coreutils}/bin/mkdir -p '${cfg.dataDir}'";
        ExecStart = "${mopidyEnv}/bin/mopidy --config ${concatStringsSep ":" ([mopidyConf] ++ cfg.extraConfigFiles)} local scan";
        Type = "oneshot";
      };
    };

    home.packages = singleton (writeShellScriptBin "mopidyctl" ''
    exec ${mopidyEnv}/bin/mopidy --config ${concatStringsSep ":" ([mopidyConf] ++ cfg.extraConfigFiles)} "$@"
    '');

  };

}
