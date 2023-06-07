{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox";
  wmClass = "firefox";
  version = "114.0";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/114.0/linux-x86_64/en-US/firefox-114.0.tar.bz2";
    sha512 = "dff334c882cb5d6fa1aff6b31c9696dd513429130984e526e9aab0fb9337c3fe6615d38274224b2846bf1de7039d7600f27d9165ce6d33c83137638186112982";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/114.0/linux-x86_64/en-US/firefox-114.0.tar.bz2.asc";
    sigSha512 = "b99c2f8d41a955f8569ea537995a4101a5b56729eeeba4454f71122c3d755efc27892d0e98709be6865b6008f64963967371093e9712b3f243966d70ab8f4565";
  };
}
