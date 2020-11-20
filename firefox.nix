{ lib }:
lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  version = "84.0b3";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/84.0b3/linux-x86_64/en-US/firefox-84.0b3.tar.bz2";
    sha512 = "97957fd7958ed9d2d5f17f62969905df6b594e71d9e5c55a353451a1e6e2548e3617c21f39baec46e10372746ac170df07a205963cad167166e3b2dc201eff9c";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/84.0b3/linux-x86_64/en-US/firefox-84.0b3.tar.bz2.asc";
    sigSha512 = "13c7eaf3ca1b597516d75f12cc2bf6f27ddeb503fe87c1cbaaf54a30a2c2662ea1a4561c63e94c6b7870f9e9cba79e7eeec24d49b90ad6448719c54721aaf7ef";
  };
}
