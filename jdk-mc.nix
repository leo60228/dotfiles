{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, makeWrapper
# minimum dependencies
, alsaLib
, fontconfig
, freetype
, libffi
, xorg
, zlib
# runtime dependencies
, cups
# runtime dependencies for GTK+ Look and Feel
, gtkSupport ? true
, cairo
, glib
, gtk3
}:

let
  runtimeDependencies = [
    cups
    alsaLib # libasound.so wanted by lib/libjsound.so
    fontconfig
    freetype
    stdenv.cc.cc.lib # libstdc++.so.6
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXrender
    xorg.libXtst
    zlib
  ] ++ lib.optionals gtkSupport [
    cairo glib gtk3
  ];
  runtimeLibraryPath = lib.makeLibraryPath runtimeDependencies;
in

let result = stdenv.mkDerivation rec {
  pname = "jdk-mc";
  version = "v15-mc+0-mc-60001";

  src = fetchurl {
    url = "https://github.com/ameisen/jdk-mc/releases/download/v15-mc%2B0-mc-60001/linux-x86_64-mc-release-zen.txz";
    sha256 = "1fg9c0vsv1vvs6zn33awp0rrqkfiaq30cqs5ag730vgbbb6w1bvh";
  };

  nativeBuildInputs = [ makeWrapper ];

  # See: https://github.com/NixOS/patchelf/issues/10
  dontStrip = 1;

  installPhase = ''
    cd ..

    mv $sourceRoot $out

    mkdir -p $out/nix-support

    # Set JAVA_HOME automatically.
    cat <<EOF >> "$out/nix-support/setup-hook"
    if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
    EOF

    # We cannot use -exec since wrapProgram is a function but not a command.
    #
    # jspawnhelper is executed from JVM, so it doesn't need to wrap it, and it
    # breaks building OpenJDK (#114495).
    for bin in $( find "$out" -executable -type f -not -name jspawnhelper ); do
      if patchelf --print-interpreter "$bin" &> /dev/null; then
        patchelf --set-interpreter "$(< "$NIX_CC/nix-support/dynamic-linker")" "$bin"
        wrapProgram "$bin" --prefix LD_LIBRARY_PATH : "${runtimeLibraryPath}"
      fi
    done
  '';

  preFixup = ''
    find "$out" -name libfontmanager.so -exec \
      patchelf --add-needed libfontconfig.so {} \;
  '';

  # FIXME: use multiple outputs or return actual JRE package
  passthru.jre = result;

  passthru.home = result;

  meta = with lib; {
    mainProgram = "java";
  };

}; in result
