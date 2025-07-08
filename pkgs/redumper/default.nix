{
  lib,
  llvmPackages_18,
  fetchFromGitHub,
  cmake,
  ninja,
  build_type ? "Release",
  # Typical values include `Debug`, `Release`, `RelWithDebInfo` and `MinSizeRel`
  # Usually set to "Release" for GitHub Actions use, so that's what it's set to by default here.
  gitUpdater,
}:

llvmPackages_18.libcxxStdenv.mkDerivation rec {
  pname = "redumper";
  version = "622";

  src = fetchFromGitHub {
    owner = "superg";
    repo = "redumper";
    rev = "build_${version}";
    hash = "sha256-pbdmEH30dlAx4LDBpXcPt3dE8tdBPqim765AyK7sgIw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    (llvmPackages_18.clang-tools.override { enableLibcxx = true; })
  ];

  env.NIX_CFLAGS_COMPILE = "-v";
  env.gh_run_version = version;

  cmakeFlags = [
    "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
    "-DREDUMPER_CLANG_LINK_OPTIONS="
    "-DREDUMPER_VERSION_BUILD=${env.gh_run_version}"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "build_"; };

  meta = with lib; {
    description = "Low level CD dumper utility";
    homepage = "https://github.com/superg/redumper";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ whovian9369 ];
    mainProgram = "redumper";
    platforms = platforms.all;
  };
}
