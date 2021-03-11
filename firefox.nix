{ lib }:
lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  version = "87.0b6";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/87.0b6/linux-x86_64/en-US/firefox-87.0b6.tar.bz2";
    sha512 = "cb6971ae8e3169a2bf0a63bc13be910fe0bda4a779804fb2bcceebcbbbbcd3455137469ca3abcda4378c3468048f342f9f6b7b93df8b16aee54425b7a58eccb0";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/87.0b6/linux-x86_64/en-US/firefox-87.0b6.tar.bz2.asc";
    sigSha512 = "9e91e4f5bca5c570433afac2bf99485979c537f917a8598898e1670b65196907be58a3a60be402ee56d4f95bebd784172251e764540d18845bd6f0990f603c43";
  };
}
