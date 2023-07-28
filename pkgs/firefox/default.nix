{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox";
  wmClass = "firefox";
  version = "115.0.3";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/115.0.3/linux-x86_64/en-US/firefox-115.0.3.tar.bz2";
    sha512 = "ea540ea9ace086c4240434e02db174f03743cfa20deb9f6eae63fc38614f344e90eb76ad0712bacf67f519c03731b0fda1010ffae0b072a92d5103b21c087d1d";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/115.0.3/linux-x86_64/en-US/firefox-115.0.3.tar.bz2.asc";
    sigSha512 = "4fd2490c2498fb6173ce220aabcc7ef045a4d2445105afe54af1434a116d3e611363560eb0f3953258a165b9d201d1ac57a8b4b889c078264aed2d796a57be55";
  };
}
