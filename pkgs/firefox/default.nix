{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "105.0b7";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/105.0b7/linux-x86_64/en-US/firefox-105.0b7.tar.bz2";
    sha512 = "0b7d9f8cf91a62cd44e8f0bb6744d5d7b1b495c7ed0e7ec1ba0db75ca46053854f7ee97e8e52e8a96421e6662e9e39f7c38842c02639739ca16cb514e69d5d5b";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/105.0b7/linux-x86_64/en-US/firefox-105.0b7.tar.bz2.asc";
    sigSha512 = "b4796e101e8b3e721eca3b177913c74628742993dfa237e00efc4707b934361f68028a2e1d5082a54128a8be468d3c3fab17137fbce679325629228e33f4ce00";
  };
}
