{ stdenv, fetchgit, autoreconfHook
, libarchive, perl, xorg, libdvdnav, libbluray
, zlib, a52dec, libmad, faad2, ffmpeg_3, alsaLib
, pkgconfig, dbus, fribidi, freefont_ttf, libebml, libmatroska
, libvorbis, libtheora, speex, lua5, libgcrypt, libgpgerror, libupnp
, libcaca, libpulseaudio, flac, schroedinger, libxml2, librsvg
, mpeg2dec, systemd, gnutls, avahi, libcddb, libjack2, SDL, SDL_image
, libmtp, unzip, taglib, libkate, libtiger, libv4l, samba, libssh2, liboggz
, libass, libva, libdvbpsi, libdc1394, libraw1394, libopus
, libvdpau, libsamplerate, live555, fluidsynth, wayland, wayland-protocols, git, bison, flex
, onlyLibVLC ? false
, withQt5 ? true, qtbase ? null, qtsvg ? null, qtx11extras ? null, qtquickcontrols2 ? null, wrapQtAppsHook ? null
, jackSupport ? false
, removeReferencesTo
, chromecastSupport ? true, protobuf, libmicrodns
}:

# chromecastSupport requires TCP port 8010 to be open for it to work.
# If your firewall is enabled, make sure to have something like:
#   networking.firewall.allowedTCPPorts = [ 8010 ];

with stdenv.lib;

assert (withQt5 -> qtbase != null && qtsvg != null && qtx11extras != null && qtquickcontrols2 != null && wrapQtAppsHook != null);

stdenv.mkDerivation rec {
  pname = "${optionalString onlyLibVLC "lib"}vlc";
  version = "4.0.0-dev";

  src = fetchgit {
    url = "https://git.videolan.org/git/vlc.git";
    rev = "345b87fc4024b2aebec7d5d46e4369123ee4585e";
    sha256 = "02ggc6dzc7q2k42a2l7dkg124mfff45bdcillf64n3pqhq1z97q3";
    leaveDotGit = true;
  };

  # VLC uses a *ton* of libraries for various pieces of functionality, many of
  # which are not included here for no other reason that nobody has mentioned
  # needing them
  buildInputs = [
    zlib a52dec libmad faad2 ffmpeg_3 alsaLib libdvdnav libdvdnav.libdvdread
    libbluray dbus fribidi libvorbis libtheora speex lua5 libgcrypt libgpgerror
    libupnp libcaca libpulseaudio flac schroedinger libxml2 librsvg mpeg2dec
    systemd gnutls avahi libcddb SDL SDL_image libmtp unzip taglib libarchive
    libkate libtiger libv4l samba libssh2 liboggz libass libdvbpsi libva
    xorg.xlibsWrapper xorg.libXv xorg.libXvMC xorg.libXpm xorg.xcbutilkeysyms
    libdc1394 libraw1394 libopus libebml libmatroska libvdpau libsamplerate
    fluidsynth wayland wayland-protocols
  ] ++ optional (!stdenv.hostPlatform.isAarch64) live555
    ++ optionals withQt5    [ qtbase qtsvg qtx11extras qtquickcontrols2 ]
    ++ optional jackSupport libjack2
    ++ optionals chromecastSupport [ protobuf libmicrodns ];

  nativeBuildInputs = [ autoreconfHook perl pkgconfig removeReferencesTo git bison flex ]
    ++ optionals withQt5 [ wrapQtAppsHook ];

  enableParallelBuilding = true;

  LIVE555_PREFIX = if (!stdenv.hostPlatform.isAarch64) then live555 else null;

  # vlc depends on a c11-gcc wrapper script which we don't have so we need to
  # set the path to the compiler
  BUILDCC = "${stdenv.cc}/bin/gcc";

  postPatch = ''
    substituteInPlace modules/text_renderer/freetype/platform_fonts.h --replace \
      /usr/share/fonts/truetype/freefont ${freefont_ttf}/share/fonts/truetype
  '';

  # - Touch plugins (plugins cache keyed off mtime and file size:
  #     https://github.com/NixOS/nixpkgs/pull/35124#issuecomment-370552830
  # - Remove references to the Qt development headers (used in error messages)
  postFixup = ''
    find $out/lib/vlc/plugins -exec touch -d @1 '{}' ';'
    $out/libexec/vlc/vlc-cache-gen $out/vlc/plugins
  '' + optionalString withQt5 ''
    remove-references-to -t "${qtbase.dev}" $out/lib/vlc/plugins/gui/libqt_plugin.so
  '';

  # Most of the libraries are auto-detected so we don't need to set a bunch of
  # "--enable-foo" flags here
  configureFlags = [
    "--with-kde-solid=$out/share/apps/solid/actions"
  ] ++ optional onlyLibVLC "--disable-vlc"
    ++ optionals chromecastSupport [
    "--enable-sout"
    "--enable-chromecast"
    "--enable-microdns"
  ];

  # Remove runtime dependencies on libraries
  postConfigure = ''
    sed -i 's|^#define CONFIGURE_LINE.*$|#define CONFIGURE_LINE "<removed>"|g' config.h
  '';

  meta = with stdenv.lib; {
    description = "Cross-platform media player and streaming server";
    homepage = "http://www.videolan.org/vlc/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    broken = if qtbase != null then versionAtLeast qtbase.version "5.15" else false;
  };
}