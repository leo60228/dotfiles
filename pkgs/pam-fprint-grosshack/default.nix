{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  gobject-introspection,
  meson,
  ninja,
  cmake,
  perl,
  gettext,
  gtk-doc,
  libxslt,
  docbook-xsl-nons,
  docbook_xml_dtd_412,
  glib,
  gusb,
  dbus,
  polkit,
  nss,
  pam,
  systemd,
  libfprint,
  python3,
  libpam-wrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pam-fprint-grosshack";
  version = "unstable-2022-07-27";

  src = fetchFromGitLab {
    owner = "mishakmak";
    repo = "pam-fprint-grosshack";
    rev = "45b42524fb5783e1e555067743d7e0f70d27888a";
    hash = "sha256-obczZbf/oH4xGaVvp3y3ZyDdYhZnxlCWvL0irgEYIi0=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    cmake
    perl # for pod2man
    gettext
    gtk-doc
    python3
    libxslt
    dbus
    docbook-xsl-nons
    docbook_xml_dtd_412
  ];

  buildInputs = [
    glib
    polkit
    nss
    pam
    systemd
    libfprint
    libpam-wrapper
  ];

  nativeCheckInputs = with python3.pkgs; [
    gobject-introspection # for setup hook
    python-dbusmock
    dbus-python
    pygobject3
    pycairo
    pypamtest
    gusb # Required by libfprint’s typelib
  ];

  mesonFlags = [
    "-Dpam_modules_dir=${placeholder "out"}/lib/security"
    "-Dsysconfdir=${placeholder "out"}/etc"
    "-Ddbus_service_dir=${placeholder "out"}/share/dbus-1/system-services"
    "-Dsystemd_system_unit_dir=${placeholder "out"}/lib/systemd/system"
  ];

  PKG_CONFIG_DBUS_1_INTERFACES_DIR = "${placeholder "out"}/share/dbus-1/interfaces";
  PKG_CONFIG_POLKIT_GOBJECT_1_POLICYDIR = "${placeholder "out"}/share/polkit-1/actions";
  PKG_CONFIG_DBUS_1_DATADIR = "${placeholder "out"}/share";

  # FIXME: Ugly hack for tests to find libpam_wrapper.so
  LIBRARY_PATH = lib.makeLibraryPath [ python3.pkgs.pypamtest ];

  mesonCheckFlags = [
    # PAM related checks are timing out
    "--no-suite"
    "fprintd:TestPamFprintd"
  ];

  postPatch = ''
    patchShebangs \
      po/check-translations.sh \
      tests/unittest_inspector.py

    substituteInPlace pam/pam_fprintd.c \
      --replace-fail "//send_info_msg" "send_info_msg"
  '';
})
