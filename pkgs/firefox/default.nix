{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox";
  wmClass = "firefox";
  version = "112.0";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/112.0/linux-x86_64/en-US/firefox-112.0.tar.bz2";
    sha512 = "80f9d922fc77d23745c5357e68f6fdc72b080db020e4a6d3b126c1f5ef5b420b0c439d58a0a27cdb39e5c14ebb8c895931acdf23b37792330318ffe81b05a36c";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/112.0/linux-x86_64/en-US/firefox-112.0.tar.bz2.asc";
    sigSha512 = "5e0b33d9adea1d468a05ed2896407098fb12d16d4bdc60c91dda8bc5d952d26e9c0575fa704c3e788034d902eebecfc4d76a5b7828fa2c25f8cd0880d7931d87";
  };
}
