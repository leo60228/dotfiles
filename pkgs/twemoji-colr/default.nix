{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "twemoji-colr";
  version = "0.5.1";

  src = fetchurl {
    url = "https://github.com/mozilla/twemoji-colr/releases/download/v${version}/TwemojiMozilla.ttf";
    sha256 = "hgtp4JblgFAVz1tdZOTs4GxbmH3AXaH5eDXHnZzHmxA=";
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm755 $src $out/share/fonts/truetype/TwemojiMozilla.ttf
  '';
}
