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
  home.sessionVariables.SSH_AUTH_SOCK = sshAuthSock;

  systemd.user.services.wsl-ssh-relay = {
    Unit = {
      Description = "Relay SSH Agent to Windows";
    };
    Service = {
      Type = "simple";
      ExecStartPre = [
        "${pkgs.coreutils}/bin/rm -f ${sshAuthSock}"
        "${pkgs.coreutils}/bin/mkdir -p ${config.home.homeDirectory}/.ssh"
      ];
      ExecStart = "${pkgs.socat}/bin/socat UNIX-LISTEN:${sshAuthSock},fork EXEC:\"${npiperelay}/bin/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent\",nofork";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
