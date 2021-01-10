{ naersk, ... }:
self: super:

{
    naersk = self.callPackage naersk rec {
        rustc = (self.callPackage ../rust.nix {}).rust;
        cargo = rustc;
    };
}
