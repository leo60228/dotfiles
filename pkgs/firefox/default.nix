{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox";
  wmClass = "firefox";
  version = "118.0";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/118.0/linux-x86_64/en-US/firefox-118.0.tar.bz2";
    sha512 = "a611a50f0b4e40858981cce3a66d4c48c8a23416ab960c1e9aa7721fb88957d66901d7055c471036c3d7382b1dd5318a3ad3610f4be2a4129355ab6c6694de77";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/118.0/linux-x86_64/en-US/firefox-118.0.tar.bz2.asc";
    sigSha512 = "75156b6753449e14f310cc1a1733259339e9f0c98973fddedc3849f4d881f8190ddce25fc3d4cf0a7037c59b2e133e417fe473b7dd3127352ad1afe7e93ab0d7";
  };
}
