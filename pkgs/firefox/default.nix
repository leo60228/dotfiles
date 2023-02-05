{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "110.0b9";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/110.0b9/linux-x86_64/en-US/firefox-110.0b9.tar.bz2";
    sha512 = "5f8e7baf91be1981188ee9238fab2eab614f6e2288d30673ec8ca989513e2aecedeb5bf1d49cd2cdad7e4173373806422237a4b862e5d5677459a66c37d1a69d";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/110.0b9/linux-x86_64/en-US/firefox-110.0b9.tar.bz2.asc";
    sigSha512 = "f0909ec5733e41dd506e0bfe64dde84cb7ef8abfa158e908270c7af246ac292ed7c25eee6e3c468441c51d448645f5384a440571d267ffbb4cb82d04d988a23c";
  };
}
