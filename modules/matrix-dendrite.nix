{ config, lib, pkgs, ... }:
let
  cfg = config.services.matrix-dendrite;
  settingsFormat = pkgs.formats.yaml { };
  configurationYaml = settingsFormat.generate "dendrite.yaml" cfg.settings;
  workingDir = "/var/lib/matrix-dendrite";
  dendriteServerCmd = lib.strings.concatStringsSep " " ([
    "${pkgs.matrix-dendrite}/bin/dendrite-monolith-server"
    "--config $configFile"
  ] ++ lib.optionals (cfg.httpPort != null) [
    "--http-bind-address :${builtins.toString cfg.httpPort}"
  ] ++ lib.optionals (cfg.httpsPort != null) [
    "--https-bind-address :${builtins.toString cfg.httpsPort}"
  ] ++ lib.optionals (cfg.tlsCert != null && cfg.tlsKey != null) [
    "--tls-cert ${cfg.tlsCert}"
    "--tls-key ${cfg.tlsKey}"
  ]);
in
{
  options.services.matrix-dendrite = {
    enable = lib.mkEnableOption "matrix.org dendrite";
    httpPort = lib.mkOption {
      type = lib.types.nullOr lib.types.port;
      default = 8008;
      description = ''
        The port to listen for HTTP requests on.
      '';
    };
    httpsPort = lib.mkOption {
      type = lib.types.nullOr lib.types.port;
      default = null;
      description = ''
        The port to listen for HTTPS requests on.
      '';
    };
    generatePrivateKey = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to generate a signing key.
      '';
    };
    generateTls = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to generate a TLS certificate and key.
      '';
    };
    tlsCert = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      example = "/var/lib/matrix-dendrite/server.cert";
      default = null;
      description = ''
        The path to the TLS certificate. Will use pre-existing cert
        if cfg.generateTls is not set true.
      '';
    };
    tlsKey = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      example = "/var/lib/matrix-dendrite/server.key";
      default = null;
      description = ''
        The path to the TLS key. Will use pre-existing key
        if cfg.generateTls is not set true.
      '';
    };
    registrationSecretFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      example = "/var/lib/matrix-dendrite/registration_secret";
      default = null;
      description = ''
        The path to the registration secret. Used to allow
        secure registration when client_api.registration_disabled is
        true.
      '';
    };
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options.global = {
          server_name = lib.mkOption {
            type = lib.types.str;
            example = "example.com";
            description = ''
              The domain name of the server, with optional explicit port.
              This is used by remote servers to connect to this server.
              This is also the last part of your UserID.
            '';
          };
          private_key = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            example = "${workingDir}/matrix_key.pem";
            default = "${workingDir}/matrix_key.pem";
            description = ''
              The path to the signing private key file, used to sign
              requests and events.
            '';
          };
          trusted_third_party_id_servers = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            example = [ "matrix.org" ];
            default = [ "matrix.org" "vector.im" ];
            description = ''
              Lists of domains that the server will trust as identity
              servers to verify third party identifiers such as phone
              numbers and email addresses
            '';
          };
          disable_federation = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              Disables federation. Dendrite will not be able to make
              any outbound HTTP requeststo other servers and the federation
              API will not be exposed.
            '';
          };
        };
        options.client_api = {
          registration_disabled = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              Whether to disable user registration to the server
              without the shared secret.
            '';
          };
        };
      };
      default = { };
      description = ''
        Configuration for dendrite, see:
        <link xlink:href="https://github.com/matrix-org/dendrite/blob/master/dendrite-config.yaml"/>
        for available options with which to populate settings.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.matrix-dendrite.tlsCert = lib.mkIf cfg.generateTls "/var/lib/matrix-dendrite/server.cert";
    services.matrix-dendrite.tlsKey = lib.mkIf cfg.generateTls "/var/lib/matrix-dendrite/server.key";

    services.matrix-dendrite.settings.client_api.registration_shared_secret = lib.mkIf (cfg.registrationSecretFile != null) "NIXOS_REGISTRATION_SECRET";

    systemd.services.matrix-dendrite = {
      description = "Dendrite Matrix homeserver";
      after = [
        "network.target"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "matrix-dendrite";
        WorkingDirectory = workingDir;
        ExecReload = "${pkgs.utillinux}/bin/kill -HUP $MAINPID";
        Restart = "on-failure";
      };
      script = lib.concatStringsSep "\n" (
        lib.optionals (cfg.registrationSecretFile != null) [
          "registrationSecret=$(cat ${cfg.registrationSecretFile})"
        ] ++ [
          ''
            configFile=$(mktemp)
            sed "s/NIXOS_REGISTRATION_SECRET/$registrationSecret/" ${configurationYaml} > "$configFile"
            ${dendriteServerCmd}
          ''
        ]
      );
    };
    systemd.services.matrix-dendrite-key-generator =
      lib.mkIf (cfg.generatePrivateKey || cfg.generateTls) {
        description = "Dendrite Matrix homeserver - Key Generator";
        requiredBy = [ "matrix-dendrite.service" ];
        before = [ "matrix-dendrite.service" ];
        path = with pkgs; [ matrix-dendrite ];
        serviceConfig = {
          Type = "oneshot";
          DynamicUser = true;
          StateDirectory = "matrix-dendrite";
          WorkingDirectory = workingDir;
          RemainAfterExit = true;
          ExecStart = lib.strings.concatStringsSep " " ([
            "${pkgs.matrix-dendrite}/bin/generate-keys"
          ] ++ lib.optionals cfg.generatePrivateKey [
            "--private-key ${cfg.settings.global.private_key}"
          ] ++ lib.optionals cfg.generateTls [
            "--tls-cert ${cfg.tlsCert}"
            "--tls-key ${cfg.tlsKey}"
          ]);
        };
      };
  };
  meta.maintainers = lib.teams.matrix.members;
}
