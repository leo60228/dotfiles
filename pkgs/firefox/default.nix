{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox";
  wmClass = "firefox";
  version = "113.0.1";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/113.0.1/linux-x86_64/en-US/firefox-113.0.1.tar.bz2";
    sha512 = "2e1df39911a92a417c42c4d2733c833558858bba5c8216b5fc4cf82a920c9dc6a8bc629cf9fb92562065799aea6423f0126972e550070960f69a21205d072afb";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/113.0.1/linux-x86_64/en-US/firefox-113.0.1.tar.bz2.asc";
    sigSha512 = "2e8f301915e86cab4f881824b28e42f42b59f58e145f18f175e0416449cb0dce78b42a63ef1400a7f3c9f01ffb9323acf2ebd7cf27a094fb9dc281a0541d34ce";
  };
}
