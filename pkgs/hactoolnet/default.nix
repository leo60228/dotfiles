{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:

buildDotnetModule rec {
  pname = "hactoolnet";
  version = "unstable-2024-08-27";

  src = fetchFromGitHub {
    owner = "Thealexbarney";
    repo = "LibHac";
    rev = "fefa38ff2204de978efdf9df1ff193d85d4d83e5";
    sha256 = "m+aHMNz0C77dJpukvkNTlTYBlUAkmJxGSB27UuNTGVc=";
  };

  projectFile = "LibHac.sln";
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  enableParallelBuilding = false; # https://github.com/dotnet/sdk/issues/2902

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
