{ naersk, ... }:
self: super:

{
  naersk = self.callPackage naersk rec {
    rustc = self.leoPkgs.rust.rust;
    cargo = rustc;
  };
}
