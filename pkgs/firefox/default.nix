{ lib }: lib.firefoxOverlay.firefoxVersion {
  name = "Firefox";
  wmClass = "firefox";
  version = "115.0.2";
  release = true;
  info = {
    url = "https://download.cdn.mozilla.net/pub/firefox/releases/115.0.2/linux-x86_64/en-US/firefox-115.0.2.tar.bz2";
    sha512 = "38ea15e1574dced96ee54238018c745dff1478f159e917447ded6e558a1df5914f9305e0121976aae95e1094884cf4d6f4e8d32e97180baa7690b16ae42a77b0";
    chksumSig = null;
    sig = "https://download.cdn.mozilla.net/pub/firefox/releases/115.0.2/linux-x86_64/en-US/firefox-115.0.2.tar.bz2.asc";
    sigSha512 = "55781085396a4d5b9428064db2db5a8ec56d1e9313d1fc28e702077875f0c489c534601dd103ff0a3e915003b7950a1e4070634fdcc6a2afb10da8dce716f768";
  };
}
