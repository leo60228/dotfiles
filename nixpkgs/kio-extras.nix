self: super: {
    kdeApplications = super.kdeApplications // {
        kio-extras = super.kdeApplications.kio-extras.overrideAttrs (oldAttrs: {
            name = "kio-extras-20.03.80";
            buildInputs = oldAttrs.buildInputs ++ [ (with self; stdenv.mkDerivation rec {
                pname = "kdsoap";
                version = "1.9.0";
                buildInputs = [ qt5.qtbase ];
                nativeBuildInputs = [ cmake ];
                postFixup = ''
                substituteInPlace $out/lib/cmake/KDSoap/KDSoapTargets.cmake --replace "$out/$out" "$out"
                '';
                #preConfigure = "touch .license.accepted";
                #configureScript = "bash ./configure.sh";
                #prefixKey = "-prefix ";
                #configureFlags = "-shared -release -qmake ${qt5.qtbase.dev}/bin/qmake";
                src = fetchurl {
                    url = "https://github.com/KDAB/KDSoap/releases/download/kdsoap-1.9.0/kdsoap-1.9.0.tar.gz";
                    sha256 = "0a28k48cmagqxhaayyrqnxsx1zbvw4f06dgs16kl33xhbinn5fg3";
                };
            }) ];
            src = self.fetchurl {
                url = "http://mirror.cc.columbia.edu/pub/software/kde/unstable/release-service/20.03.80/src/kio-extras-20.03.80.tar.xz";
                sha256 = "1rvcsfb47bg7jb1lq8rf8agjwb0fich3ksm4hvjg7aiyq6kz4hgh";
                name = "kio-extras-20.03.80.tar.xz";
            };
        });
    };
}
