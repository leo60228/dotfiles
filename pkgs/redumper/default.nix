{
  lib,
  llvmPackages_18,
  fetchFromGitHub,
  cmake,
  ninja,
  gitUpdater,
}:

llvmPackages_18.libcxxStdenv.mkDerivation rec {
  pname = "redumper";
  version = "663";

  src = fetchFromGitHub {
    owner = "superg";
    repo = "redumper";
    rev = "b${version}";
    hash = "sha256-PJVoFVzIIncu/oBJAbvB/JQVc7cIVoYa4rAlLXmj34I=";
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

  passthru.updateScript = gitUpdater { rev-prefix = "b"; };

  meta = with lib; {
    description = "Low level CD dumper utility";
    homepage = "https://github.com/superg/redumper";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ whovian9369 ];
    mainProgram = "redumper";
    platforms = platforms.all;
  };
}
