{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox";
  wmClass = "firefox";
  version = "116.0.3";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/116.0.3/linux-x86_64/en-US/firefox-116.0.3.tar.bz2";
    sha512 = "d4b10656148fdb9f14e7cd6f393fcd7841a98508582b01800640a6121fe1be1f9db1c0812554481925b1c350b29d00291c0ab2b8c64a26acbd5d78163e8c9645";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/116.0.3/linux-x86_64/en-US/firefox-116.0.3.tar.bz2.asc";
    sigSha512 = "4d39f8e1171a50dde14b5a33434419fb1f025adc2b1f6198f1702c9252e8aa717ebcc9364479c11560316e4f348f719a52d03bc66fcbd0ecfa3ad0fc90fb12c8";
  };
}
