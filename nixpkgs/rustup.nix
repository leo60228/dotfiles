{ nixpkgs-unstable, ... }:
self:
super:

{
    rustup = self.callPackage "${nixpkgs-unstable}/pkgs/development/tools/rust/rustup" {
        inherit (self.darwin.apple_sdk.frameworks) CoreServices Security;
    };
}
