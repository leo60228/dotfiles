{ makeRustPlatform, fetchFromGitHub, stdenv, callPackage, pkgconfig, openssl }:
let rust = (callPackage ./rust.nix {}).channel.rust;
    nightlyRustPlatform = makeRustPlatform { cargo = rust; rustc = rust; }; in
nightlyRustPlatform.buildRustPackage rec {
    pname = "celeste.rs";
    version = "4.0.0";

    src = fetchFromGitHub {
        owner = "leo60228";
        repo = pname;
        rev = "a4fe2c1fc9b8c7cb99460d0b6d553cbd834455a1";
        sha256 = "1kbc4419kd1dah17mzsifl6kd8r647r2jx5hk5jim90akxix0qvc";
    };

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ openssl ];

    cargoSha256 = "08dpivb81pbqvjslwni7q4w1j5qcg8az6wn2mc4gi2i76kcf819j";
    verifyCargoDeps = true;

    meta = with stdenv.lib; {
        description = "Crate for formats from the 2018 game Celeste";
        homepage = https://github.com/leo60228/celeste.rs;
        license = licenses.mit;
        maintainers = [ maintainers.leo60228 ];
        platforms = platforms.all;
    };
}

