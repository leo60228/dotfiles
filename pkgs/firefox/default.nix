{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "103.0b2";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/103.0b2/linux-x86_64/en-US/firefox-103.0b2.tar.bz2";
    sha512 = "1511af982aab2fcc7199105047d48fd6480883fd4e3859332007d94487d166fa8cd8ec70b45a036075b7ca5278fa3992e150d0d2cd07f4d626b6073dcd0ac12c";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/103.0b2/linux-x86_64/en-US/firefox-103.0b2.tar.bz2.asc";
    sigSha512 = "4e5af4771977dc993e2a3eb4667a69f26b6339fa970118c9a390da5dc2a57ef23d0daea15dfdeb5e5cb1e028d3d8f1687ca3b8bf145b40f127df76d4b0e346d7";
  };
}
