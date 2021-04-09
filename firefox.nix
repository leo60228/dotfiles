{ lib }:
lib.firefoxOverlay.firefoxVersion {
  name = "Firefox Beta";
  version = "88.0b9";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/88.0b9/linux-x86_64/en-US/firefox-88.0b9.tar.bz2";
    sha512 = "663b1305139dc983920176d0e590acb832b2c1b446e37080eb0b776da48a0f5a06954fde70e647e3c63cb3e5f27aa07e40e0cbf5f83ef0e888a005007644aa00";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/88.0b9/linux-x86_64/en-US/firefox-88.0b9.tar.bz2.asc";
    sigSha512 = "4ef78a6ec9d3d4443de21a68625ed152f076f79425d5091d5bb037ca4889211aeff885441942a9fae65a6c49e5cda4976b3ecb55683b45ecb8bb435dee74d060";
  };
}
