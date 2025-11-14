self: super: {
  vgmstream = super.vgmstream.overrideAttrs (oldAttrs: {
    cmakeFlags = oldAttrs.cmakeFlags ++ [ "-DBUILD_SHARED_LIBS=ON" ];
  });

  mpd = super.mpd.overrideAttrs (oldAttrs: {
    version = "0.24.4-unstable-2025-05-24";
    src = self.fetchFromGitHub {
      owner = "MusicPlayerDaemon";
      repo = "MPD";
      rev = "cf7b9e06bd7e1b877e5c5243a22efe938b0036f2";
      hash = "sha256-pPdOY9F+k/eRkeH2DVHgwQHMFFYKlfneeDz3tE/fruc=";
    };
    buildInputs = oldAttrs.buildInputs ++ [ self.vgmstream ];
    mesonFlags = oldAttrs.mesonFlags ++ [ "-Dvgmstream=enabled" ];
  });
}
