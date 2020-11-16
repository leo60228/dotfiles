{ clangStdenv, stdenvNoCC, makeWrapper, cmake, fetchFromGitHub, dotnetCorePackages, runCommand, fetchurl, dotnetPackages }:
let
  coreclr-version = "3.1.2";
  coreclr-src = fetchFromGitHub {
    owner = "dotnet";
    repo = "coreclr";
    rev = "v${coreclr-version}";
    sha256 = "1wk8d7f2j8k4xd61lhwv91w8ji7la80nkcyz4my0fs7nzvlk46a7";
  };
  dotnet-sdk = dotnetCorePackages.sdk_3_1;

  pname = "netcoredbg";
  version = "1.2.0-635";

  src = fetchFromGitHub {
    owner = "Samsung";
    repo = pname;
    rev = version;
    sha256 = "0cq9awvfprcs5fzqj50y6bbynlwhs2bkqym979fwala10ilqyy52";
  };

  unmanaged = clangStdenv.mkDerivation rec {
    inherit src pname version;

    patches = [ ../files/default-missing-frame.patch ];

    nativeBuildInputs = [ cmake ];

    cmakeFlags = [
      "-DCORECLR_DIR=${coreclr-src}"
      "-DDOTNET_DIR=${dotnet-sdk}"
      "-DBUILD_MANAGED=0"
      "-DDBGSHIM_RUNTIME_DIR=${dotnet-sdk}/shared/Microsoft.NETCore.App/${coreclr-version}"
    ];
  };

  deps = import ./deps.nix { inherit fetchurl; };

  # Build the nuget source needed for the later build all by itself
  # since it's a time-consuming step that only depends on ./deps.nix.
  # This makes it easier to experiment with the main build.
  nugetSource = stdenvNoCC.mkDerivation {
    pname = "netcoredbg-nuget-deps";
    inherit version;

    dontUnpack = true;

    nativeBuildInputs = [ dotnetPackages.Nuget ];

    buildPhase = ''
    export HOME=$(mktemp -d)

    mkdir -p $out/lib

    # disable default-source so nuget does not try to download from online-repo
    nuget sources Disable -Name "nuget.org"
    # add all dependencies to the source
    for package in ${toString deps}; do
      nuget add $package -Source $out/lib
    done
    '';

    dontInstall = true;
  };

  managed = stdenvNoCC.mkDerivation {
    inherit pname version src;

    buildInputs = [ dotnet-sdk ];
    nativeBuildInputs = [ dotnetPackages.Nuget ];

    buildPhase = ''
    mkdir -p $out/lib

    export HOME=$(mktemp -d)
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1

    pushd src
    nuget sources Disable -Name "nuget.org"
    dotnet restore --source ${nugetSource}/lib debug/netcoredbg/SymbolReader.csproj
    popd

    pushd src/debug/netcoredbg
    dotnet build --no-restore -c Release SymbolReader.csproj
    popd
    '';

    installPhase = ''
    pushd src/debug/netcoredbg
    dotnet publish --no-restore -o $out/lib -c Release SymbolReader.csproj
    popd
    '';
  };
in stdenvNoCC.mkDerivation {
  inherit pname version;

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
  mkdir -p $out
  cp ${unmanaged}/* $out
  cp ${managed}/lib/* $out
  makeWrapper $out/netcoredbg $out/bin/netcoredbg
  '';
}
