{
  lib,
  llvmPackages_18,
  fetchFromGitHub,
  cmake,
  ninja,
  build_type ? "Release",
# Typical values include `Debug`, `Release`, `RelWithDebInfo` and `MinSizeRel`
# Usually set to "Release" for GitHub Actions use, so that's what it's set to by default here.
}:

llvmPackages_18.libcxxStdenv.mkDerivation rec {
  pname = "redumper";
  version = "build_426";

  src = fetchFromGitHub {
    owner = "superg";
    repo = "redumper";
    rev = version;
    hash = "sha256-YAhxkltnun17Ky8L7PS05ZL4UTUY6nId+dVucYTdllo=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    (llvmPackages_18.clang-tools.override { enableLibcxx = true; })
  ];

  env.NIX_CFLAGS_COMPILE = "-v";
  env.gh_run_version = lib.removePrefix "build_" version;

  cmakeFlags = [
    "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
    "-DREDUMPER_CLANG_LINK_OPTIONS="
    "-DREDUMPER_VERSION_BUILD=${env.gh_run_version}"
  ];

  meta = with lib; {
    description = "Low level CD dumper utility";
    homepage = "https://github.com/superg/redumper";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ whovian9369 ];
    mainProgram = "redumper";
    platforms = platforms.all;
  };
}
