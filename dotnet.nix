{ stdenv
, lib
, fetchurl
, libunwind
, openssl
, icu
, libuuid
, zlib
, curl
}:

let
  rpath = lib.makeLibraryPath [ stdenv.cc.cc libunwind libuuid icu openssl zlib curl ];
in
  stdenv.mkDerivation rec {
    version = "3.0.100-preview7-012821";
    netCoreVersion = "3.0-preview7";
    pname = "dotnet-sdk";

    src = fetchurl {
      url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-linux-x64.tar.gz";
      # use sha512 from the download page
      sha512 = "DF70CA86453CEBA51B480BC8521D6BF76625469CDD3DA6FE782B85F13620D8BEEB34E02EE7AFE2803CD144066E7C685E5A1A9A4005ADC9B2709C69F7F37C9BDC";
    };

    sourceRoot = ".";

    buildPhase = ''
      runHook preBuild
      patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" ./dotnet
      patchelf --set-rpath "${rpath}" ./dotnet
      patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" ./sdk/${version}/AppHostTemplate/apphost
      patchelf --set-rpath "${rpath}" ./sdk/${version}/AppHostTemplate/apphost
      patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" ./packs/Microsoft.NETCore.App.Host.linux-x64/*/runtimes/linux-x64/native/apphost
      patchelf --set-rpath "${rpath}" ./packs/Microsoft.NETCore.App.Host.linux-x64/*/runtimes/linux-x64/native/apphost
      find -type f -name "*.so" -exec patchelf --set-rpath '$ORIGIN:${rpath}' {} \;
      echo -n "dotnet-sdk version: "
      ./dotnet --version
      runHook postBuild
    '';

    dontPatchELF = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp -r ./ $out
      ln -s $out/dotnet $out/bin/dotnet
      runHook postInstall
    '';

    meta = with lib; {
      homepage = https://dotnet.github.io/;
      description = ".NET Core SDK ${version} with .NET Core ${netCoreVersion}";
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ kuznero ];
      license = licenses.mit;
    };
  }
