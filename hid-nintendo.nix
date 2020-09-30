{ stdenv, fetchFromGitHub, kernel ? null }:

stdenv.mkDerivation {
  pname = "hid_nintendo";
  version = "0.3.0";
  src = fetchFromGitHub {
    owner = "nicman23";
    repo = "dkms-hid-nintendo";
    rev = "ca684eacf372a21bacffaddf018c2ea2b776a07f";
    sha256 = "0wyiq4xv8qxw7iyyhnx47a3ygsgzc0ns08sa0fy1kj3ryarwizp2";
  };
  preBuild = ''
    cp --no-preserve=mode,owner -r $src/src ./src
  '';
  buildPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$PWD/src
  '';
  installPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$PWD/src modules_install
  '';
  INSTALL_MOD_PATH = placeholder "out";
  postBuild = "ls -l";
}
