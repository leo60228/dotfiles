{ lib }:
lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  version = "89.0b2";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/89.0b2/linux-x86_64/en-US/firefox-89.0b2.tar.bz2";
    sha512 = "b9836d991af65d0f160c8e95ea825d9619ff9da58af96fff1934e88be7d9e52fa8687b4bec603fcbc9e4459aca5434c5bde9e94ede54a8ae39a08790501a3a30";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/89.0b2/linux-x86_64/en-US/firefox-89.0b2.tar.bz2.asc";
    sigSha512 = "92487e391b075b6195a16a16da27d29195a65c14bc4cc810f91ad3e9e6bb7f378b4a5f285a478391160acd8c1e35923ff560fe3dcc9f4652b3f60a6f46a0fcac";
  };
}
