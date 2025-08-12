{
  stdenvNoCC,
  lib,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "datapath-vision-firmware";
  version = "7.27.1.40643";

  dontConfigure = true;
  dontBuild = true;

  src = fetchurl {
    url = "https://www.datapathsoftware.com/supportdownloads/linux/vision-driver-app/VisionInstall-${version}.tar.gz";
    hash = "sha256-7XHpWaE34HY41Z4oXyae6mj3Os2WJ4EMqUlxKSL9Lww=";
  };

  sourceRoot = "firmware";

  installPhase = ''
    install -Dm644 DGC*FW*.BIN -t $out/lib/firmware/
  '';

  meta = with lib; {
    description = "Firmware for Vision/VisionAV/VisionSC capture cards";
    homepage = "https://www.datapathsoftware.com/downloads/";
    license = licenses.unfree;
    maintainers = with maintainers; [ leo60228 ];
    platforms = platforms.linux;
  };
}
