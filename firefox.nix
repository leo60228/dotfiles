{ lib }:
lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  version = "84.0b2";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/84.0b2/linux-x86_64/en-US/firefox-84.0b2.tar.bz2";
    sha512 = "fb06ccfdef0290850e71d8c45d04f237ac154df53a80a3d139f3cb051b0fa505bea7a83685b4395c6320ef3897e4ee7b1b47577208a401290cb88c84a706e78f";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/84.0b2/linux-x86_64/en-US/firefox-84.0b2.tar.bz2.asc";
    sigSha512 = "6890a8588d19fd713d54231bc38ac8467a9a8d63bab6f41dec024a53775aa01bf2d3229da310b41abd52cb93034e5f4e537a6d61319fae8f535b565169014e0a";
  };
}
