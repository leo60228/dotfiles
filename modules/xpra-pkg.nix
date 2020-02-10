let pkgs = import <nixpkgs> {}; in {
  xpra = (pkgs.xpra.override {
    pulseaudio = pkgs.pulseaudioFull;
  }).overrideAttrs (oldAttrs: rec {
    pname = "xpra";
    version = "3.0.5";
    name = "${pname}-${version}";
    src = pkgs.fetchurl {
      url = "https://xpra.org/src/${pname}-${version}.tar.xz";
      sha256 = "1zy4q8sq0j00ybxw3v8ylaj2aj10x2gb0a05aqbcnrwp3hf983vz";
    };
    patches = with pkgs; [
      (substituteAll {
        src = ../files/fix-paths.patch;
        inherit (xorg) xkeyboardconfig;
      })
    ];
  });
  xpra-html5 = builtins.fetchTarball {
    url = "https://xpra.org/src/xpra-html5-3.0.5.tar.xz";
    sha256 = "19i1qfbhqdfp5ny1z4ws7bpv7wilv2bpi4v6ql3amijr9rp9qvk6";
  };
}
