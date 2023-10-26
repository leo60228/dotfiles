{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox";
  wmClass = "firefox";
  version = "118.0.2";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/118.0.2/linux-x86_64/en-US/firefox-118.0.2.tar.bz2";
    sha512 = "561ba9aae59cdde3ff5d0b37fcf4f13a7f07e2257af63e290a64b84c207b5481b03b266d8c00ff14c136fa20392949d5532a713fdab8b151307400092c811c93";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/118.0.2/linux-x86_64/en-US/firefox-118.0.2.tar.bz2.asc";
    sigSha512 = "c09472ab31f2268e675892b2b64015d071bd9e393549f7eb8db53f5ccad005886c61b7f66d7c8d291bbfe95f4d0c74a5da5f1870f261b0e7854dd09a111b5f4c";
  };
}
