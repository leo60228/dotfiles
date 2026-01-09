{
  lib,
  stdenvNoCC,
  runCommand,
  pyproject-nix,
  pyproject-build-systems,
  uv2nix,
  callPackage,
  python3,
  libarchive,
  writeScript,
}:

let
  baseSet = callPackage pyproject-nix.build.packages {
    python = python3;
  };
  script = uv2nix.lib.scripts.loadScript { script = ./fetcher.py; };
  fetcher = writeScript "fetcher.py" (
    script.renderScript {
      venv = script.mkVirtualEnv {
        pythonSet = baseSet.overrideScope (
          lib.composeManyExtensions [
            pyproject-build-systems.overlays.wheel
            (script.mkOverlay { sourcePreference = "wheel"; })
            (self: super: {
              httpio = super.httpio.overrideAttrs (oldAttrs: {
                nativeBuildInputs =
                  (oldAttrs.nativeBuildInputs or [ ])
                  ++ self.resolveBuildSystem {
                    setuptools = [ ];
                  };
              });
            })
          ]
        );
      };
    }
  );
in
stdenvNoCC.mkDerivation {
  pname = "office-fonts";
  version = "2007";

  src =
    runCommand "office-fonts-src"
      {
        outputHashMode = "recursive";
        outputHash = "sha256-unbiYm7lBGt4xy0/ul3VFOylAUbQV8GF44MVJWDbt5I=";
      }
      ''
        mkdir $out
        cd $out
        LIBARCHIVE="${libarchive.lib}/lib/libarchive.so" ${fetcher}
      '';

  installPhase = ''
    runHook preInstall

    shopt -s extglob
    install -Dm644 !(SEGOE*|CONSOLA*).TTF -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    maintainers = with maintainers; [ leo60228 ];
    platforms = platforms.all;
  };
}
