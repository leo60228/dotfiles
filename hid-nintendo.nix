{ stdenv, fetchFromGitHub, kernel ? null }:

stdenv.mkDerivation {
  pname = "hid_nintendo";
  version = "3.2";
  src = fetchFromGitHub {
    owner = "nicman23";
    repo = "dkms-hid-nintendo";
    rev = "6f78c51cd3e4292976ee5304f9dedc316acf5a31";
    sha256 = "2a+95zwyhJsF/KSo/Pm/JZ7ktDG02UZjsixSnVUXRrA=";
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
