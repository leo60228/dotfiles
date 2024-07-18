{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:

buildDotnetModule rec {
  pname = "hactoolnet";
  version = "unstable-2024-06-16";

  src = fetchFromGitHub {
    owner = "Thealexbarney";
    repo = "LibHac";
    rev = "559b8c89f9ba2913f5e8e6630ecb2c21c13dcd31";
    sha256 = "m8NNsfnQNFLuPHunKMw2k0avbkH5/p/+Ucx/nwU7JPQ=";
  };

  projectFile = "LibHac.sln";
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  executables = [ "hactoolnet" ];

  packNupkg = true;

  preConfigure = "unset version";

  meta = with lib; {
    homepage = "https://github.com/Thealexbarney/LibHac";
    description = "Library and command line tool that reimplements parts of the Nintendo Switch OS";
    mainProgram = "hactoolnet";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ leo60228 ];
  };
}
