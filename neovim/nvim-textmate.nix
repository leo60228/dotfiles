{ vimUtils, fetchgit, stdenv, lib, python3, autoconf, automake, libtool, cmake, lua }:
vimUtils.buildVimPlugin {
  pname = "nvim-textmate";
  version = "git-2022-09-24";
  src = fetchgit {
    url = "https://github.com/icedman/nvim-textmate.git";
    rev = "b6f372cb63cbf6ddcab3d61251066f2ee0b4c540";
    sha256 = "1sbp3vrdkxzypw8jm7ycip2qhq95lkwsd9in4mibsjw7a3dfvg6c";
  };
  nativeBuildInputs = [ python3 autoconf automake libtool cmake lua ];
  dontConfigure = true;
  postPatch = "patchShebangs .";
  buildPhase = ''
  runHook preBuild
  make prebuild
  make build
  runHook postBuild
  '';
  installPhase = ''
  runHook preInstall
  mkdir -p $out/lua
  cp -R ./lua/nvim-textmate $out/lua/
  runHook postInstall
  '';
  meta = {
    homepage = https://github.com/icedman/nvim-textmate;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
