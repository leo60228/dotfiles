{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "103.0b8";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/103.0b8/linux-x86_64/en-US/firefox-103.0b8.tar.bz2";
    sha512 = "3c34053b35fbf01f6cb819420c315a01aca664e83ef918c666f3b730c03fc2717531bdb1e8f7b0be91fc843400085bae7be9f0e25433551ded7d1111d1100594";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/103.0b8/linux-x86_64/en-US/firefox-103.0b8.tar.bz2.asc";
    sigSha512 = "70ba7d5049a996a62dbcfd95456c90681e096e0ac2973491c7e2c507cbd2adc856a024ee52f8e6016a85a5c29558c9d2394ccd2b16c974eb9a1291b85233dea1";
  };
}
