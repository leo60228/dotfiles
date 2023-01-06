{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "109.0b9";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/109.0b9/linux-x86_64/en-US/firefox-109.0b9.tar.bz2";
    sha512 = "08b195806999866dbc72217207ffe5f37850db69e83bbefe35b4ecf8e286cd04e63a3eff35ecc6cb8d6a9847882706d9347611c5a9c42a63ca9ff51021ebfa3d";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/109.0b9/linux-x86_64/en-US/firefox-109.0b9.tar.bz2.asc";
    sigSha512 = "bf5f9ab5170b2397816fb3d036a8bf3b42f627ee736443071c2631ba44b51f8833fcca5768562cfafebfe603fa3ea398847a210c2e69bcf83d80d5baed70e93d";
  };
}
