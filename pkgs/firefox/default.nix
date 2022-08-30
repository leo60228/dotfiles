{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  wmClass = "firefox-beta";
  version = "105.0b4";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/105.0b4/linux-x86_64/en-US/firefox-105.0b4.tar.bz2";
    sha512 = "626800b22acb68fff366b047607a4297d4e409f7fb5a63fefab5fe5a0ba0712f49e3fd54405fffc984d4f2e1a814b622d2c437a1344b97932a54d5e1645de54b";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/105.0b4/linux-x86_64/en-US/firefox-105.0b4.tar.bz2.asc";
    sigSha512 = "a29694ba799a8efb445e357f6a1736c1b04b3fb93a2d1bab8447f1142335d7ea87be35a2b45d61aeb819d3eecdb96075f2bd8b5439576c6f8213d12451258add";
  };
}
