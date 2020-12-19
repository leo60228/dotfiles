{ stdenv, fetchFromGitHub, cmake, discord-rpc, mpd_clientlib }:

stdenv.mkDerivation rec {
  name = "mpd-rich-presence-discord";
  version = "1.0";
  src = fetchFromGitHub {
    owner = "justas-d";
    repo = name;
    rev = "ced628d3eaf3f18c5eff286b0955c605616348ee";
    sha256 = "0vl31sdgxalbnc4d4fggzqs2vsssibn53pjm6wj596cfkfpdf4y3";
  };
  nativeBuildInputs = [ cmake mpd_clientlib ];
  buildInputs = [ discord-rpc ];
  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];
  installPhase = ''
    install -D mpd_discord_richpresence $out/bin/mpd_discord_richpresence
  '';
}
