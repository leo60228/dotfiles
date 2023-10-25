{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox";
  wmClass = "firefox";
  version = "119.0";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/119.0/linux-x86_64/en-US/firefox-119.0.tar.bz2";
    sha512 = "1c71258ce1037fbcdddac889181776fa6017dea5fba738b65855e7bbe785db9ad596c3b458483107917164ceeca3ca9ec25c638d3ba67bd4c7a6a3a179deb066";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/119.0/linux-x86_64/en-US/firefox-119.0.tar.bz2.asc";
    sigSha512 = "965dd5ea98f88eaf44f9cbe2abb7340715a39e5316c4a3b85f3b6135feb94f951512fad5a59ac4744d75d01a6e3e811b87b2b80897b4adb2f44eb3e85e04a0e0";
  };
}
