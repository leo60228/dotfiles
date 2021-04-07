{ lib }:
lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  version = "88.0b8";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/88.0b8/linux-x86_64/en-US/firefox-88.0b8.tar.bz2";
    sha512 = "0491b374451d217ba44b39fe03d32076258415ea9794c4428657bb885a7211805adc8ea0522334afde7598d5759735446e6e8bdc55f88b0b21fefc3ed1da7a71";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/88.0b8/linux-x86_64/en-US/firefox-88.0b8.tar.bz2.asc";
    sigSha512 = "4187b6235f8ed0bf43833a71c2b277d8a08b15d0a4b8c2422bfb866c43f91bc087fe3edbfa3bdab340c469460ca760a8a16c2f791ef92b970fb7cb51100deb13";
  };
}
