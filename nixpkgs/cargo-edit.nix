self: super:

{
    cargo-edit = self.callPackage ../cargo-edit.nix {
        inherit (self.darwin.apple_sdk.frameworks) Security;
        rustPlatform = self.makeRustPlatform rec {
            rustc = (self.callPackage ../rust.nix {}).channel.rust;
            cargo = rustc;
        };
    };
}
