{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "twemoji-color-font";
  version = "13.0.1";

  # We fetch the prebuilt font because building it takes 1.5 hours on hydra.
  # Relevant issue: https://github.com/NixOS/nixpkgs/issues/97871
  src = fetchurl {
    url = "https://github.com/eosrei/twemoji-color-font/releases/download/v${version}/TwitterColorEmoji-SVGinOT-Linux-${version}.tar.gz";
    sha256 = "1mn2cb6a3v0q8i81s9a8bk49nbwxq91n6ki7827i7rhjkncb0mbn";
  };

  dontBuild = true;

  installPhase = ''
    install -Dm755 TwitterColorEmoji-SVGinOT.ttf $out/share/fonts/truetype/TwitterColorEmoji-SVGinOT.ttf
  '';

  meta = with lib; {
    description = "Color emoji SVGinOT font using Twitter Unicode 10 emoji with diversity and country flags";
    longDescription = ''
      A color and B&W emoji SVGinOT font built from the Twitter Emoji for
      Everyone artwork with support for ZWJ, skin tone diversity and country
      flags.

      The font works in all operating systems, but will currently only show
      color emoji in Firefox, Thunderbird, Photoshop CC 2017, and Windows Edge
      V38.14393+. This is not a limitation of the font, but of the operating
      systems and applications. Regular B&W outline emoji are included for
      backwards/fallback compatibility.
    '';
    homepage = "https://github.com/eosrei/twemoji-color-font";
    downloadPage = "https://github.com/eosrei/twemoji-color-font/releases";
    license = with licenses; [ cc-by-40 mit ];
    maintainers = [ maintainers.fgaz ];
  };
}