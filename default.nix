{
  system ? builtins.currentSystem,
}:
with (import (
  let
    lock = builtins.fromJSON (builtins.readFile ./flake.lock);
    inherit (lock.nodes.flake-compat.locked) narHash rev url;
  in
  builtins.fetchTarball {
    url = "${url}/archive/${rev}.tar.gz";
    sha256 = narHash;
  }
) { src = ./.; }).defaultNix;
rec {
  inherit (inputs.nixpkgs) lib;
  leoPkgs =
    (import inputs.nixpkgs {
      inherit system overlays;
    }).leoPkgs;
  overlays = (builtins.attrValues (lib.removeAttrs outputs.overlays [ "default" ])) ++ [
    (self: super: {
      leoPkgs = self.callPackages ./pkgs { };
    })
  ];
}
