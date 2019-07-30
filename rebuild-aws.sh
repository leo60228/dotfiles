#!/bin/sh
cd "$(dirname $0)"
NIXOS_CONFIG="$(pwd)/aws.nix" nixos-rebuild --build-host root@ghostnet.leo60228.space --target-host root@ghostnet.leo60228.space "$@"
