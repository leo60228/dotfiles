{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox";
  wmClass = "firefox";
  version = "117.0.1";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/117.0.1/linux-x86_64/en-US/firefox-117.0.1.tar.bz2";
    sha512 = "2c6bfd88b4b136ea1f09e2afe17b7a0ecdee60bba3a6aff1c6fcae0ff119902e19ccb629b72880ec3b2b8e4cb4c76c7961d850ba719e8e8fbd71eeedfc7bc1c6";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/117.0.1/linux-x86_64/en-US/firefox-117.0.1.tar.bz2.asc";
    sigSha512 = "442afb93be508fb19451ebf0e6e2c2996283f496f6cf7cc762464753a7fdbfa15863a02021415c98960703c507f9d0f641acb42905604ae0bb3319ce65888114";
  };
}
