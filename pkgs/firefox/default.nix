{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "104.0b8";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/104.0b8/linux-x86_64/en-US/firefox-104.0b8.tar.bz2";
    sha512 = "723179279cb980753f4af754814790aeea0ed9efcb0272152566d5d44f05df9d72e2e16ed5619661d2f5b559484d3fe63a1338f4d00dc4fab075cdd8c7f11c5d";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/104.0b8/linux-x86_64/en-US/firefox-104.0b8.tar.bz2.asc";
    sigSha512 = "c9e6fde6e7800f1f78dadb4ac1e52d4b897c3e77eba8b6aaae9d9e028024f7390a2cd1a66a912f7744001e53ab05429c83a06afb5dd67faf36e571cec054a437";
  };
}
