{
  lib,
  stdenvNoCC,
  runCommand,
  poetry2nix,
  libarchive,
}:

let
  dl = poetry2nix.mkPoetryApplication {
    projectDir = ./.;
    overrides = poetry2nix.defaultPoetryOverrides.extend (
      final: prev: {
        pycdlib = prev.pycdlib.overridePythonAttrs (old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ prev.setuptools ];
        });
        httpio = prev.httpio.overridePythonAttrs (old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ prev.setuptools ];
        });
        libarchive-c = prev.libarchive-c.overridePythonAttrs (old: {
          postPatch =
            (old.postPatch or "")
            + ''
              echo "Patching find_library call."
              substituteInPlace libarchive/ffi.py \
                --replace-warn "find_library('archive')" "\"${libarchive.lib}/lib/libarchive.so\""
            '';
        });
      }
    );
  };
in
stdenvNoCC.mkDerivation rec {
  pname = "office-fonts";
  version = "2007";

  src =
    runCommand "office-fonts-src"
      {
        outputHashMode = "recursive";
        outputHash = "sha256-unbiYm7lBGt4xy0/ul3VFOylAUbQV8GF44MVJWDbt5I=";
        nativeBuildInputs = [ dl ];
      }
      ''
        mkdir $out
        cd $out
        dl
      '';

  installPhase = ''
    runHook preInstall

    install -Dm644 *.TTF -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    maintainers = with maintainers; [ leo60228 ];
    platforms = platforms.all;
  };
}
