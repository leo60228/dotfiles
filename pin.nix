{rev, sha256}:
import (builtins.fetchTarball {
  name = "pinned-nixpkgs";
  url = "https://github.com/nixos/nixpkgs/archive/${rev}.tar.gz";
  inherit sha256;
}) {}
