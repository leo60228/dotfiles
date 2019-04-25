#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nixops
#export SSH_AUTH_SOCK=''

cd "$(dirname $0)"
nixops info -d systems 2>/dev/null >/dev/null || nixops create ./nixops.nix -d systems
nixops set-args --arg skip null -d systems
if [[ "x$1" != "x" ]]; then
  nixops set-args --argstr skip "$1" -d systems
fi
nixops deploy -d systems --show-trace
