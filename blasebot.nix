{ makeRustPlatform, fetchFromGitHub, stdenv, callPackage, pkgconfig, openssl }:
let rust = (callPackage ./rust.nix {}).channel.rust;
    nightlyRustPlatform = makeRustPlatform { cargo = rust; rustc = rust; }; in
nightlyRustPlatform.buildRustPackage rec {
    pname = "blasebot";
    version = "0.1.0";

    src = fetchFromGitHub {
        owner = "leo60228";
        repo = pname;
        rev = "d7c0bb46785eb73a87fcd634f21473d690ed6f98";
        sha256 = "11jsm02vqlv70dpqjmcjk6abbjy6ygdcygzsggf8602a6a4bfn50";
    };

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ openssl ];

    cargoSha256 = "0cs06rjqsi0qfgavw7l01qvxang4wsb6msscfzm9xxp1sz3nzjqy";
    verifyCargoDeps = true;

    OPENSSL_NO_VENDOR = "1";
}

