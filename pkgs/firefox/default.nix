{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox";
  wmClass = "firefox";
  version = "118.0.1";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/118.0.1/linux-x86_64/en-US/firefox-118.0.1.tar.bz2";
    sha512 = "e6ea959927d352987386178f2141e6342b2d789545f0d92058e042ec66df144de9b1826e0079857b5a546c98cc9d41f391c9e11bbe86a219b5a25ed2fa14c6d0";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/118.0.1/linux-x86_64/en-US/firefox-118.0.1.tar.bz2.asc";
    sigSha512 = "a716432b21a8798c550068487ee239b3bf6c42eeeca0757bbdfcefd11f5a95a68d49e69d34aea81f18f096f6af949a38d43386879702da7f6267e133ccb1cd05";
  };
}
