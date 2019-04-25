{config, pkgs, lib, ...}:
let
  cfg = config.services.gitAnnexServer;
in
with lib; {
  options = {
    services.gitAnnexServer = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = ''
          Start a git-annex ssh server.
        '';
      };
      
      user = mkOption {
        default = "annex";
        type = with types; uniq string;
        description = ''
          Name of the git-annex ssh login.
        '';
      };
      
      keys = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          A list of verbatim OpenSSH public keys that should be added to the
          git-annex user's authorized keys.
        '';
      };

      path = mkOption {
        default = "/home/annex";
        type = with types; uniq string;
        description = ''
          Path to where git-annex repositories are stored.
        '';
      };
    };
  };

  config = let annexShellWrapper = pkgs.writeShellScriptBin "annex-shell-wrapper" ''
    exec ${pkgs.bash}/bin/bash -c "${pkgs.gitAndTools.git-annex}/bin/git-annex-shell$(printf " %q" "$@")"
  ''; in mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gitAndTools.git-annex pkgs.git ];

    services.openssh.enable = true;
    services.openssh.passwordAuthentication = mkDefault false;
    services.openssh.challengeResponseAuthentication = mkDefault false;
    
    users.groups.git-annex = {};

    users.users.${cfg.user} = {
      openssh.authorizedKeys.keys = cfg.keys;
      createHome = true;
      isSystemUser = true;
      shell = "${pkgs.git}/bin/git-shell";
      home = cfg.path;
      group = "git-annex";
      packages = with pkgs; [ bash git gitAndTools.git-annex ] ++ [ annexShellWrapper ];
    };

    system.activationScripts.annex = ''
      cd "${cfg.path}"
      mkdir -p git-shell-commands
      cd git-shell-commands
      rm -f git-annex-shell
      ln -s "${annexShellWrapper}/bin/annex-shell-wrapper" ./git-annex-shell
    '';
  };
}
