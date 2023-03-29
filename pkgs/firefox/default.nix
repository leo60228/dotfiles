{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "112.0b8";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/112.0b8/linux-x86_64/en-US/firefox-112.0b8.tar.bz2";
    sha512 = "eb698a35bbc2c67905df4da7045fe53f7477c9465c6dfa154b5d14af3646b560b13dd78eb82e201046b52c86b1db9c06d9a0298a359d2c1775eb3dfcc72e300d";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/112.0b8/linux-x86_64/en-US/firefox-112.0b8.tar.bz2.asc";
    sigSha512 = "55828479b25ce5f2890999ec1972936c16a0f912d6f0cf692ebccb20f09184ff574f76542cbd667c0540315413146f4653a84afd3f7dea76548a83a1f6a03bd0";
  };
}
