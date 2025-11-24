# derived from https://github.com/lukadev-0/dotfiles/blob/925d0c01531267ac2e5f4f3aa4a9736698178c83/home/with/wsl-ssh-relay.nix
{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:

let
  sshAuthSock = "${config.home.homeDirectory}/.ssh/agent.sock";
  npiperelay = pkgs.stdenv.mkDerivation rec {
    pname = "npiperelay";
    version = "1.9.1";
    src = pkgs.fetchurl {
      url = "https://github.com/albertony/npiperelay/releases/download/v${version}/npiperelay_windows_amd64.exe";
      hash = "sha256-1/CerFoHKpMXe9iqkhNhbrZocwWMi5phuKHz1MHpLrs=";
    };
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin/
      cp $src $out/bin/npiperelay.exe
      chmod +x $out/bin/npiperelay.exe
    '';
  };
in
lib.mkIf (osConfig.wsl.enable or false) {
  home.packages = [ pkgs.gnupg ];
  home.sessionVariables.SSH_AUTH_SOCK = sshAuthSock;

  systemd.user.services =
    let
      services = {
        relay-ssh-agent = {
          path = sshAuthSock;
          args = "-ei -s //./pipe/openssh-ssh-agent";
        };
        relay-gpg-agent = {
          path = "/run/user/1000/gnupg/S.gpg-agent";
          args = "-ei -a C:/Users/leo60228/AppData/Local/gnupg/S.gpg-agent";
        };
        relay-gpg-extra = {
          path = "/run/user/1000/gnupg/S.gpg-agent.extra";
          args = "-ei -a C:/Users/leo60228/AppData/Local/gnupg/S.gpg-agent.extra";
        };
      };
      genService =
        name:
        { path, args }:
        {
          Service = {
            Type = "simple";
            ExecStartPre = [
              "${pkgs.coreutils}/bin/rm -f ${path}"
              "${pkgs.coreutils}/bin/mkdir -p ${builtins.dirOf path}"
            ];
            ExecStart =
              let
                escapedArgs = lib.escape [ ":" "\\" ] args;
                escapedExec = lib.escapeShellArg "${npiperelay}/bin/npiperelay.exe ${escapedArgs}";
                command = "${pkgs.socat}/bin/socat UNIX-LISTEN:${path},fork EXEC:${escapedExec},nofork";
              in
              lib.escape [ "\\" ] command;
            Restart = "on-failure";
          };
          Install = {
            WantedBy = [ "default.target" ];
          };
        };
    in
    lib.mapAttrs genService services;
}
