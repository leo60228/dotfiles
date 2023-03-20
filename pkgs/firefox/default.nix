{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "112.0b4";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/112.0b4/linux-x86_64/en-US/firefox-112.0b4.tar.bz2";
    sha512 = "ee6e6cdd9dee8d97348da8ff2848b9b33ccd554790a66e90871b1e4103f963860ff9ab535f3349470b40c527c9ffbc292b1b2b765d6d6249d2702e0d3aa05407";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/112.0b4/linux-x86_64/en-US/firefox-112.0b4.tar.bz2.asc";
    sigSha512 = "52d4d4954fd1f97b5cbd4fc126a6f5f19298cc9d4e698de41787412de1a83660341224570035b1554cf7cd9643532894dfb9eca1449aff22fd6349dc96e2986d";
  };
}
