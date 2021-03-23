{ lib }:
lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  version = "88.0b1";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/88.0b1/linux-x86_64/en-US/firefox-88.0b1.tar.bz2";
    sha512 = "90ef761350dff6d93159d08a1ced6b1009a75c1c56f5352a77ff91f28bcd268886c645dd9b7628e474dba8a735d71122f3d5f21ee0b474d89a89c260fd975e19";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/88.0b1/linux-x86_64/en-US/firefox-88.0b1.tar.bz2.asc";
    sigSha512 = "a2192607e007f020756ea3f4caf212e2b8da4177905ae6a6706a0167468cbf2390c4fed51c05070a366786958902ffca6e0eb7e7f878e6c317ffd5176de0ae5c";
  };
}
