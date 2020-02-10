{ stdenvNoCC, perl }: stdenvNoCC.mkDerivation {
    name = "leobin";
    src = ./bin;
    buildInputs = [ perl ];
    installPhase = ''
    mkdir -p $out/bin
    cp -r $src/* $out/bin
    '';
}
