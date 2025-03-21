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
{
  leoPkgs = outputs.legacyPackages.${system};
  overlays =
    (builtins.attrValues (inputs.nixpkgs.lib.removeAttrs outputs.overlays [ "default" ]))
    ++ [
      (self: super: {
        leoPkgs = self.callPackages ./pkgs { };
      })
    ];
}
