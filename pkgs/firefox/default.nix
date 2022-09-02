{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "105.0b6";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/105.0b6/linux-x86_64/en-US/firefox-105.0b6.tar.bz2";
    sha512 = "c7ecb6b885f93ba9701c8d811cb367ebdb15ca0d605e97399b02913741bedc2baf86a2fa428a8095c92d7ec8838edcd06e015a3a2ee6ec0379369bd3257cb78e";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/105.0b6/linux-x86_64/en-US/firefox-105.0b6.tar.bz2.asc";
    sigSha512 = "6b80495e6c4f56f9cfcf68a6d487b8713c59582eef49585cae33985f79dcd54e7e9fe745886231b5acc1ccc62a6cf908a27565a95e24aa26af288de018f62382";
  };
}
