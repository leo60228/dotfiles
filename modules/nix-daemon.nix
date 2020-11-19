{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.nix;

  nix = cfg.package.out;

  nixVersion = getVersion nix;

  isNix23 = versionAtLeast nixVersion "2.3pre";

  nixConf =
    assert versionAtLeast nixVersion "2.2";
    pkgs.runCommand "nix.conf" { preferLocalBuild = true; extraOptions = cfg.extraOptions; } (
      ''
        cat > $out <<END
        # WARNING: this file is generated from the nix.* options in
        # your NixOS configuration, typically
        # /etc/nixos/configuration.nix.  Do not edit it!
        build-users-group = nixbld
        max-jobs = ${toString (cfg.maxJobs)}
        cores = ${toString (cfg.buildCores)}
        sandbox = ${if (builtins.isBool cfg.useSandbox) then boolToString cfg.useSandbox else cfg.useSandbox}
        sandbox-paths = ${toString cfg.sandboxPaths}
        substituters = ${toString cfg.binaryCaches}
        trusted-substituters = ${toString cfg.trustedBinaryCaches}
        trusted-public-keys = ${toString cfg.binaryCachePublicKeys}
        auto-optimise-store = ${boolToString cfg.autoOptimiseStore}
        require-sigs = ${boolToString cfg.requireSignedBinaryCaches}
        trusted-users = ${toString cfg.trustedUsers}
        allowed-users = ${toString cfg.allowedUsers}
        ${optionalString (!cfg.distributedBuilds) ''
          builders =
        ''}
        system-features = ${toString cfg.systemFeatures}
        ${optionalString isNix23 ''
          sandbox-fallback = false
        ''}
        $extraOptions
        END
      '' + optionalString cfg.checkConfig (
            if pkgs.stdenv.hostPlatform != pkgs.stdenv.buildPlatform then ''
              echo "Ignore nix.checkConfig when cross-compiling"
            '' else ''
              echo "Checking that Nix can read nix.conf..."
              ln -s $out ./nix.conf
              NIX_CONF_DIR=$PWD ${cfg.package}/bin/nix show-config ${optionalString isNix23 "--no-net --option experimental-features nix-command"} >/dev/null
            '')
      );

in

{
  config = {
    nix.extraOptions = ''
    warn-dirty = false
    '';
    environment.etc."nix/nix.conf".source = lib.mkForce nixConf;
  };
}
