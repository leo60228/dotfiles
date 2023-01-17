{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "110.0b1";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/110.0b1/linux-x86_64/en-US/firefox-110.0b1.tar.bz2";
    sha512 = "815915f4507db6db3c05388c081e1ab0c219f98fbf3588002d05b8975b65215a78200e573a96f88b3bd5a46cef8b63a7c05874841986f11571013113dde75299";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/110.0b1/linux-x86_64/en-US/firefox-110.0b1.tar.bz2.asc";
    sigSha512 = "8a2a5cc96ff3a737b2d1400a2b83b1c7e1cdd223dcd756073ce0dce489d09d39b2553ae9a64ae4f0a717f6c3a57ea8f84160c90d3734c3582b67ab7333ed20f4";
  };
}
