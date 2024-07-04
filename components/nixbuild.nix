let
  lib = import ../lib;
in
lib.makeComponent "nixbuild" (
  {
    cfg,
    pkgs,
    lib,
    ...
  }:
  with lib;
  {
    opts = {
      systems = mkOption {
        default = [ "aarch64-linux" ];
        type = types.listOf types.str;
      };
    };

    config = {
      nix.distributedBuilds = true;
      nix.buildMachines = [
        {
          inherit (cfg) systems;
          supportedFeatures = [
            "big-parallel"
            "benchmark"
          ];
          sshKey = "/home/leo60228/.ssh/id_ed25519";
          maxJobs = 100;
          hostName = "eu.nixbuild.net";
        }
      ];
      nix.extraOptions = ''
        builders-use-substitutes = true
      '';
    };
  }
)
