{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "103.0b6";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/103.0b6/linux-x86_64/en-US/firefox-103.0b6.tar.bz2";
    sha512 = "6a65c4412807ff0f38b6fcc3d7fcde6be04d265e32b619b845cd0c75c59227fb95949f84e7c25e36fefa998c153ea8717bcef6db458f2a3e75cfce3d92b33ca7";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/103.0b6/linux-x86_64/en-US/firefox-103.0b6.tar.bz2.asc";
    sigSha512 = "8d633fc7b93ad1508aab2546775b490a9d6ccd24658ea14cd6f1332f60680a2f832e7c51e7f5be9a31317b4f94f561b7f42c2c45337943b09f1e57166a71cd4d";
  };
}
