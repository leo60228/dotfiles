#!/usr/bin/env bash
set -e
nixOpts=(-L --option experimental-features 'nix-command flakes')
if [ -z "$_BOOTSTRAP_REEXEC" ]; then
  export _BOOTSTRAP_REEXEC=1
  exec nix run nixpkgs.nixFlakes -c nix "${nixOpts[@]}" run '.#nix' -- "${nixOpts[@]}" run '.#bootstrap' -- "$@"
fi
hostname="${1:?hostname missing}"
shift
nixos-rebuild switch --flake ".#${hostname}" "$@"
