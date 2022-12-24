{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "109.0b6";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/109.0b6/linux-x86_64/en-US/firefox-109.0b6.tar.bz2";
    sha512 = "2c920dc7354e79f9b7bfce1d15e753cda137d1801f608dd344471ef5341f089d7973be1583e678f5320a90a16a6fc19772a4759821dc444d667c70bd1aed6c2c";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/109.0b6/linux-x86_64/en-US/firefox-109.0b6.tar.bz2.asc";
    sigSha512 = "4385f69d9452281201632b3aaafd47719d2b1385e6d6304075489dd3e26cdf4ed12f94389fe1584f32c569018771ef4031a136e3d5deaab98b7846a0509ec667";
  };
}
