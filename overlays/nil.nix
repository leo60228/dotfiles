self: super:

{
  nil = super.nil.overrideAttrs (
    oldAttrs:
    assert oldAttrs.version == "2025-06-13";
    rec {
      version = "2026-07-23";

      src = self.fetchFromGitHub {
        owner = "oxalica";
        repo = "nil";
        rev = version;
        hash = "sha256-upJVI2pq9sOKgF2AILt8l6O4/3GNcMtT/s0rmnbO5UA=";
      };

      cargoHash = "sha256-ZyTrxGX0mRdskxp4o5ssDCyZzNn36rIgP9fDaA1fDws=";
      cargoDeps = self.rustPlatform.fetchCargoVendor {
        inherit (oldAttrs) pname;
        inherit version src;
        hash = cargoHash;
      };
    }
  );
}
