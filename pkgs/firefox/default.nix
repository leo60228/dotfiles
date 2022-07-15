{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "103.0b9";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/103.0b9/linux-x86_64/en-US/firefox-103.0b9.tar.bz2";
    sha512 = "cc668fc0ccf2029afb2640fa955ceefca24907dc3fae472cc3b24865d071cd03f3d22e017b769f1c675f077f67f35bf81ec1304fbc930b131b19fbd0b2407c35";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/103.0b9/linux-x86_64/en-US/firefox-103.0b9.tar.bz2.asc";
    sigSha512 = "bf7d3d5dc6c0ef2298efcfabb01955731ddee8aa5a32c092d4bbbeed96c43d50997b61b4b6e21e51606f2089394d2814565487f847ea8fe08bc8a510424aa6e6";
  };
}
