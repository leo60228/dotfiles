{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "vxis-capture-fw-mod";
  version = "unstable-2021-05-27";

  src = fetchFromGitHub {
    owner = "maximus64";
    repo = "vxis-capture-fw-mod";
    rev = "19db148aebb9c2b5cc24f11b41919f4ac1659ad2";
    sha256 = "/fjY2WRPEQx0JOqjV9fhW7zuS53lBv68GkT4ohbia7U=";
  };

  sourceRoot = "source/flasher";

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin i2c_vs9989 flasher xdata
    runHook postInstall
  '';
}
