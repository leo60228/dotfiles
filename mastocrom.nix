{ makeRustPlatform, fetchFromGitHub, stdenv, callPackage, pkgconfig, openssl }:
let rust = (callPackage ./rust.nix {}).channel.rust;
    nightlyRustPlatform = makeRustPlatform { cargo = rust; rustc = rust; }; in
nightlyRustPlatform.buildRustPackage rec {
    pname = "mastocrom";
    version = "0.1.0";

    src = fetchFromGitHub {
        owner = "leo60228";
        repo = pname;
        rev = "9ae1825f26bd8868471ecf5c4a95bd8b44c6d000";
        sha256 = "1w9fnc1frxb3bzm19wzkm452sniy4g88v0s02q3xji38xfcjkxr2";
    };

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ openssl ];

    cargoSha256 = "1scqfmpj23jc26c4lqqarkwd2b0kfq6vk8q9gd8caxc54dqyk4s2";
    verifyCargoDeps = true;

    OPENSSL_NO_VENDOR = "1";
}

