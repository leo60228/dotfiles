{ stdenv, cmake, pkgconfig, libevdev, libudev, fetchFromGitHub }:
stdenv.mkDerivation {
  pname = "joycond";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "DanielOgorchock";
    repo = "joycond";
    rev = "3969af9dcdc2b8199716ec08220df5d9ef7cfc6a";
    sha256 = "16jsv0fvs9s3yhiiy8mkccclzyzy55ym69zhxv9jprk5xhq707ag";
  };

  nativeBuildInputs = [ cmake pkgconfig libevdev libudev ];

  configurePhase = "cmake . -DCMAKE_INSTALL_PREFIX=$out";
  dontBuild = true;
  installPhase = ''
  make DESTDIR=$out install
  mv $out/usr/bin $out/bin
  rmdir $out/usr
  '';
}
