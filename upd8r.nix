{ makeRustPlatform, fetchFromGitHub, stdenv, callPackage, pkgconfig, openssl }:
let rust = (callPackage ./rust.nix {}).channel.rust;
    nightlyRustPlatform = makeRustPlatform { cargo = rust; rustc = rust; }; in
nightlyRustPlatform.buildRustPackage rec {
    pname = "upd8r";
    version = "0.1.0";

    src = fetchFromGitHub {
        owner = "leo60228";
        repo = pname;
        rev = "455215ad1e156aed7dc809ced806d7873ab19334";
        sha256 = "1gr5gl6lj6xd8fgiaaxv3p3d1g6frwasqhjmd8ad2m7gq2b10nr4";
    };

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ openssl ];

    cargoSha256 = "0jciim3cczpbrsfk41agw5l1x7nakfj12lq7rfmh759szx6csdyc";
    verifyCargoDeps = true;

    OPENSSL_NO_VENDOR = "1";
}

