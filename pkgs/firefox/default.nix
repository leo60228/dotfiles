{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "108.0b9";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/108.0b9/linux-x86_64/en-US/firefox-108.0b9.tar.bz2";
    sha512 = "2403417f101f76795a5722a6a8a9d63e796bf15df7f03c7df57172d6f887f5bb3f22d64bde5c95e600a61ca79ed8199e0aab3101894e8f77f4cee52b56238800";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/108.0b9/linux-x86_64/en-US/firefox-108.0b9.tar.bz2.asc";
    sigSha512 = "d2e427d24947bca954c5ccd7afa30ac19fa22e999e81ff1b8838156f627c0c943ef027019bbdcb11ef27810bd258b2f607c7ff059a88f84328279031c64294a9";
  };
}
