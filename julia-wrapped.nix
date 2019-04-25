{ pkgs ? import <nixpkgs> {}, juliapkg ? pkgs.julia }: with pkgs; stdenvNoCC.mkDerivation rec {
  name = "julia-wrapped";
  version = "${juliapkg.version}";
  
  ldPath = lib.makeLibraryPath [ imagemagickBig cairo gettext pango glib gtk3 gdk_pixbuf gzip zlib gcc-unwrapped.lib ];

  trueWrapper = pkgs.writeScript "true" ''
  ${coreutils}/bin/true
  '';

  src = pkgs.writeShellScriptBin "julia-wrapper" ''
set -e

GTK3_SCHEMA=(${gtk3}/share/gsettings-schemas/*)
GSETTINGS_SCHEMA=(${gsettings_desktop_schemas}/share/gsettings-schemas/*)
export XDG_DATA_DIRS="$XDG_DATA_DIRS:''${GSETTINGS_SCHEMA[@]}:''${GTK3_SCHEMA[@]}"

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${ldPath}"
PROOT_NO_SECCOMP=1 exec ${proot}/bin/proot -b "${trueWrapper}":/sbin/ldconfig "${juliapkg}/bin/julia" "$@"
  '';

  unpackCmd = "";

  installPhase = ''
    mkdir -p $out/bin
    cp ${src}/bin/julia-wrapper $out/bin/julia_${builtins.concatStringsSep "" (lib.take 2 (lib.splitString "." version))}
  '';
}
