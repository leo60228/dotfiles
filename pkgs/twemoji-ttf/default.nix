{
  lib,
  stdenv,
  fetchurl,
  fetchFromSourcehut
}:

stdenv.mkDerivation rec {
  pname = "twemoji-ttf";
  version = "15.1.0";

  srcs = [
    (fetchFromSourcehut {
      owner = "~whynothugo";
      repo = "twemoji.ttf";
      rev = "1680b0ee54e691086f74dfb941cd504c68b51946";
      hash = "sha256-A2ctiZ4l7t3rVS+U6ENU451ITZdzlHkF0Pby4Ue1MCU=";
    })
    (fetchurl {
      url = "https://artefacts.whynothugo.nl/twemoji.ttf/2024-06-06_17-55/Twemoji-15.1.0.ttf";
      hash = "sha256-SyHnTDMo2V/9TEHDkE5zx+HXwWXs4gddkOiCCHkfmUg=";
    })
  ];

  preUnpack = "unpackCmdHooks+=('cp $curSrc .')";
  sourceRoot = ".";

  installPhase = ''
    install -Dm644 *.ttf $out/share/fonts/truetype/Twemoji-${version}.ttf
    install -Dm644 source/75-twemoji.conf $out/etc/fonts/conf.d/75-twemoji.conf
  '';
}
