{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "104.0b6";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/104.0b6/linux-x86_64/en-US/firefox-104.0b6.tar.bz2";
    sha512 = "0ca3638365bff4b08ea2acbce2b2925d57431411d1c6300ad438912efd2d9b2d3f2016d0d2c02c55b2eaaf514772424a8dddb3d46f05af655c9fdc2c78245dbc";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/104.0b6/linux-x86_64/en-US/firefox-104.0b6.tar.bz2.asc";
    sigSha512 = "fbb33ea5edbbbad9a7b0250a16598e4965cd974e3136c2740312c978209d3e6da74572866ae7e2f85c77803cce28cd78004dfb109233cc8ac3615d1ec426a80a";
  };
}
