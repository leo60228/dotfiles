{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "109.0b2";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/109.0b2/linux-x86_64/en-US/firefox-109.0b2.tar.bz2";
    sha512 = "3dd499ab2b01e18911efd3773385cc4378cb8c158ecd8600ccdab49c440341262db0cf8e719c80fafac0d02fc844a1eefd3f36c9bdbeae8197cb7ef8e00be32d";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/109.0b2/linux-x86_64/en-US/firefox-109.0b2.tar.bz2.asc";
    sigSha512 = "cd40fc758f6f157f4f7a7e502753a60582b260599ec38da32fa0be56a851c538bf70dd1096d1675bdf1e952ac1b71feac52ec761476a229cf7d9432a94e8a2d4";
  };
}
