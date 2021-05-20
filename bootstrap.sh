#!/usr/bin/env bash
set -e
nixOpts=(-L --option experimental-features 'nix-command flakes' --option builders 'ssh://ec2-user@3.82.18.227 - /home/leo60228/.ssh/id_rsa 64 - big-parallel' --option builders-use-substitutes true --option max-jobs 0)
if [ -z "$_BOOTSTRAP_REEXEC" ]; then
  export _BOOTSTRAP_REEXEC=1
  exec nix run nixpkgs.nixFlakes -c nix "${nixOpts[@]}" run '.#nix' -- "${nixOpts[@]}" run '.#bootstrap' -- "$@"
fi
hostname="${1:?hostname missing}"
shift
nixos-rebuild switch --flake ".#${hostname}" "$@"
