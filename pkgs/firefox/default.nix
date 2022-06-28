{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "103.0b1";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/103.0b1/linux-x86_64/en-US/firefox-103.0b1.tar.bz2";
    sha512 = "10ab446f8537256f2b3a01bbe00644fc117a2b9c5a3d5ce116e49bcd6ea89daf3b907514ba93c68c09ea952303fe7ef3c0aca9cc072554d7e6380da41fd63e2c";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/103.0b1/linux-x86_64/en-US/firefox-103.0b1.tar.bz2.asc";
    sigSha512 = "262ee9d949fd128d4398f453fa1265f46069f34b92a1c99d8caa1cb7fb03242a1d2b9d2f5761d000807ecc78db0358f8c9592482391606debe180e97c832162a";
  };
}
