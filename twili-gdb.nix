{ gdb, fetchFromGitHub, gmp, mpfr, expat, flex, bison, gnused }:

gdb.overrideAttrs (oldAttrs: {
    name = "twili-gdb";

    patches = [];

    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ flex bison gnused ];

    src = fetchFromGitHub {
        owner = "misson20000";
        repo = "twili-gdb";
        rev = "7a53ef3a8b2c247f0ca897eacd9239b25bcf76ba";
        sha256 = "1hk6pj3j2ny0snbiz0iyy7xbvrc1s76xjsj4dcdlq5wzkp9dnl4a";
    };

    configureFlags = [
        "--enable-targets=twili"
        "--target=twili"

        "--enable-64-bit-bfd"
        "--disable-install-libbfd"
        "--disable-shared" "--enable-static"
        "--with-system-zlib"
        "--with-system-readline"

        "--with-gmp=${gmp.dev}"
        "--with-mpfr=${mpfr.dev}"
        "--with-expat" "--with-libexpat-prefix=${expat.dev}"
    ];
})
