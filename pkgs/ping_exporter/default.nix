{ buildGoPackage }:

buildGoPackage rec {
  name = "ping_exporter";

  goPackagePath = "github.com/czerwonk/ping_exporter";

  src = ./.;

  goDeps = ./deps.nix;
}
