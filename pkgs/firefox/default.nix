{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "105.0b8";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/105.0b8/linux-x86_64/en-US/firefox-105.0b8.tar.bz2";
    sha512 = "eddc64e6204a0702efc6b7a3ae63381cf3cd260b2f8e4aee120d2946ef927dc92588d19eef5f6ec19f467ee91b91538571979012602cee43e1e1400c68ec283d";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/105.0b8/linux-x86_64/en-US/firefox-105.0b8.tar.bz2.asc";
    sigSha512 = "d9f9df40c5e16b37a75e8888da50cfb03f35f1d8ccae291fda5c42ea6a778a238eda65cc6f2c35b31603149ebceaf29e755dd7476b2b2f85339fdf5b2c2514b7";
  };
}
