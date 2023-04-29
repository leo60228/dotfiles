{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox";
  wmClass = "firefox";
  version = "112.0.2";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/112.0.2/linux-x86_64/en-US/firefox-112.0.2.tar.bz2";
    sha512 = "7789c95d582530f28b33c1ceeb67bfff246064f4b483bf8185fff7117b86de29ad5c855acc533474e42bf35dfac52cc0c9a39e4c73d84b7ecc24e80c6fa08adc";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/112.0.2/linux-x86_64/en-US/firefox-112.0.2.tar.bz2.asc";
    sigSha512 = "037fb528d72f74c286afe6d230d81b1bcd13097c29fcaeba3bcf0f2d2eeb62f5e09b9eb2d154c20ea1d3e25212dab5a988351b5697e09b9f4ea799a676d4ffbb";
  };
}
