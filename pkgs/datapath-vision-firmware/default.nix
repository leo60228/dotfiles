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
    sha256 = "1995klvpvps3k25w0ly1qvhm9n73ad58yp87ln2n34nrf3bynhiq";
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
