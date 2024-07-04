{ stdenvNoCC, perl }:
stdenvNoCC.mkDerivation {
  name = "leobin";
  src = ./.;
  buildInputs = [ perl ];
  installPhase = ''
    shopt -s extglob
    mkdir -p $out/bin
    cp -r $src/!(default.nix) $out/bin
  '';
}
