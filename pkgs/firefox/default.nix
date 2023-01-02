{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "109.0b7";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/109.0b7/linux-x86_64/en-US/firefox-109.0b7.tar.bz2";
    sha512 = "ac129da7845cf438170ed197d8c4e40a3f6ffd79638697d2d787a672cc060917f50bee2490296db5e6e56de54189154810593ce15a7b3d27fc6d3152a95ba4f1";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/109.0b7/linux-x86_64/en-US/firefox-109.0b7.tar.bz2.asc";
    sigSha512 = "a40800edfb197516a15b66b9704c3be7e4d2e3b3984477d7c767120c54cc30122348703647acbf9051dc5dd27c90068b45f09bb0d38c702aaee7b3a29dda7de4";
  };
}
