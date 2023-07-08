{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox";
  wmClass = "firefox";
  version = "115.0.1";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/115.0.1/linux-x86_64/en-US/firefox-115.0.1.tar.bz2";
    sha512 = "0c60bfc79850e9ab2929c0e25b72bb78a9aa9d4557d5274a7464dface232291bbd04beb8efa07a1b8d5a0351a4d3a61aad1801914b4de14659aa3ce6ff36edf7";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/115.0.1/linux-x86_64/en-US/firefox-115.0.1.tar.bz2.asc";
    sigSha512 = "d11994aa1c5c1771b935c42e6852766a793384a9f2ebf94dec6021b5f36707430ee4787330db6241edad11b440a706d7ecc9ca288b18ad87175452c8c2cceab4";
  };
}
