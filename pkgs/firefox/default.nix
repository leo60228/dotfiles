{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "105.0b2";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/105.0b2/linux-x86_64/en-US/firefox-105.0b2.tar.bz2";
    sha512 = "51925d2e2cdcd57c02203ebf4efb18d3955ec428213f5e322c42899a87b8bf08cc4fcfe6a8bf794e4c97193e20efa5340f79bd454a7eea529ab0e4a992b670ab";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/105.0b2/linux-x86_64/en-US/firefox-105.0b2.tar.bz2.asc";
    sigSha512 = "883272936a42c6bd44967083558050ee940c271513cd69703f0955ecfa0a7353f10ebba5437685e93044a74df6c9e66e8f21e1a1d375a86d55d9e65b07b066f7";
  };
}
