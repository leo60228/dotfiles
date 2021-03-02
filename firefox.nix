{ lib }:
lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  version = "87.0b3";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/87.0b3/linux-x86_64/en-US/firefox-87.0b3.tar.bz2";
    sha512 = "51fe015e54b648420ccfa4d43cd5cfb4b19765eb5a93fe525d81497c63cddb2c9a37f71366b50e0673fbe147c52e2bfef62f3241d30e6402c32946e3670114e7";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/87.0b3/linux-x86_64/en-US/firefox-87.0b3.tar.bz2.asc";
    sigSha512 = "d90d5332041762a84f8a4368410e18fb9e1adb465d20cadb908385ac6feefab8277d19864b17c4f5c4ac88bed2d25ab2037990374f11fe3609c483728bc35544";
  };
}
