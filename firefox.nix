{ lib }:
lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  version = "88.0b2";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/88.0b2/linux-x86_64/en-US/firefox-88.0b2.tar.bz2";
    sha512 = "cb712d765de8e7860b8625633b483f2202ef628b5cf5a116e91f38b9b49cfb8d6bf8a6ff347912137d4c24d6d89ec43c8c72eefc93b35e8e425d763861f85527";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/88.0b2/linux-x86_64/en-US/firefox-88.0b2.tar.bz2.asc";
    sigSha512 = "d51c5e0c4c5ab8f3cc2ddc438917c4d96cff8d556f57f2445028125e8cff29605a970a47129df12cbb6e7cf48f32616302b3efedebdf194434e2db15a54b4d05";
  };
}
