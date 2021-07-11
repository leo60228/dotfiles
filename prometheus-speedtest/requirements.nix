# generated using pypi2nix tool (version: 2.0.4)
# See more at: https://github.com/nix-community/pypi2nix
#
# COMMAND:
#   pypi2nix -e prometheus-speedtest
#

{ pkgs ? import <nixpkgs> {},
  overrides ? ({ pkgs, python }: self: super: {})
}:

let

  inherit (pkgs) makeWrapper;
  inherit (pkgs.lib) fix' extends inNixShell;

  pythonPackages =
  import "${toString pkgs.path}/pkgs/top-level/python-packages.nix" {
    inherit pkgs;
    inherit (pkgs) stdenv lib;
    python = pkgs.python3;
  } pythonPackages;

  commonBuildInputs = [];
  commonDoCheck = false;

  withPackages = pkgs':
    let
      pkgs = builtins.removeAttrs pkgs' ["__unfix__"];
      interpreterWithPackages = selectPkgsFn: pythonPackages.buildPythonPackage {
        name = "python3-interpreter";
        buildInputs = [ makeWrapper ] ++ (selectPkgsFn pkgs);
        buildCommand = ''
          mkdir -p $out/bin
          ln -s ${pythonPackages.python.interpreter} \
              $out/bin/${pythonPackages.python.executable}
          for dep in ${builtins.concatStringsSep " "
              (selectPkgsFn pkgs)}; do
            if [ -d "$dep/bin" ]; then
              for prog in "$dep/bin/"*; do
                if [ -x "$prog" ] && [ -f "$prog" ]; then
                  ln -s $prog $out/bin/`basename $prog`
                fi
              done
            fi
          done
          for prog in "$out/bin/"*; do
            wrapProgram "$prog" --prefix PYTHONPATH : "$PYTHONPATH"
          done
          pushd $out/bin
          ln -s ${pythonPackages.python.executable} python
          ln -s ${pythonPackages.python.executable} \
              python3
          popd
        '';
        passthru.interpreter = pythonPackages.python;
      };

      interpreter = interpreterWithPackages builtins.attrValues;
    in {
      __old = pythonPackages;
      inherit interpreter;
      inherit interpreterWithPackages;
      mkDerivation = args: pythonPackages.buildPythonPackage (args // {
        nativeBuildInputs = (args.nativeBuildInputs or []) ++ args.buildInputs;
      });
      packages = pkgs;
      overrideDerivation = drv: f:
        pythonPackages.buildPythonPackage (
          drv.drvAttrs // f drv.drvAttrs // { meta = drv.meta; }
        );
      withPackages = pkgs'':
        withPackages (pkgs // pkgs'');
    };

  python = withPackages {};

  generated = self: {
    "absl-py" = python.mkDerivation {
      name = "absl-py-0.10.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/49/7c/1d9fa17c363b5ff395cc6f5fd03219b9d303f31268983325974570d0d500/absl-py-0.10.0.tar.gz";
        sha256 = "b20f504a7871a580be5268a18fbad48af4203df5d33dbc9272426cb806245a45";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [
        self."six"
      ];
      meta = with pkgs.lib; {
        homepage = "https://github.com/abseil/abseil-py";
        license = licenses.asl20;
        description = "Abseil Python Common Libraries, see https://github.com/abseil/abseil-py.";
      };
    };

    "mock" = python.mkDerivation {
      name = "mock-4.0.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/2e/35/594f501b2a0fb3732c8190ca885dfdf60af72d678cd5fa8169c358717567/mock-4.0.2.tar.gz";
        sha256 = "dd33eb70232b6118298d516bbcecd26704689c386594f0f3c4f13867b2c56f72";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.lib; {
        homepage = "http://mock.readthedocs.org/en/latest/";
        license = licenses.bsdOriginal;
        description = "Rolling backport of unittest.mock for all Pythons";
      };
    };

    "prometheus-client" = python.mkDerivation {
      name = "prometheus-client-0.8.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/d4/e4/04c85d441194059e063e866847c04dbba11b9428bee8d3b8d086fb9a8c51/prometheus_client-0.8.0.tar.gz";
        sha256 = "c6e6b706833a6bd1fd51711299edee907857be10ece535126a158f911ee80915";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.lib; {
        homepage = "https://github.com/prometheus/client_python";
        license = licenses.asl20;
        description = "Python client for the Prometheus monitoring system.";
      };
    };

    "prometheus-speedtest" = python.mkDerivation {
      name = "prometheus-speedtest-0.9.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/03/91/b5d58a4c23570ec0ecc688f4a1172b7fced0a00d03493cbf4e56d682369f/prometheus_speedtest-0.9.4.tar.gz";
        sha256 = "6574173ca6a5f02af90d6d9d6138fb6200931a980713d2b24e1b65208a0491e5";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [
        self."absl-py"
        self."mock"
        self."prometheus-client"
        self."speedtest-cli"
      ];
      meta = with pkgs.lib; {
        homepage = "https://github.com/jeanralphaviles/prometheus_speedtest";
        license = licenses.asl20;
        description = "Performs speedtest-cli tests and pushes metrics to Prometheus Pushgateway";
      };
    };

    "six" = python.mkDerivation {
      name = "six-1.15.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz";
        sha256 = "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.lib; {
        homepage = "https://github.com/benjaminp/six";
        license = licenses.mit;
        description = "Python 2 and 3 compatibility utilities";
      };
    };

    "speedtest-cli" = python.mkDerivation {
      name = "speedtest-cli-2.1.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/5c/c8/296057f78f16721863f9edb5abdb0d2648c5c6932697f29d80d920fdcd91/speedtest-cli-2.1.2.tar.gz";
        sha256 = "cf1d386222f94c324e3125ba9a0d187e46d4a13dca08c023bdb9a23096be2e54";
};
      doCheck = commonDoCheck;
      format = "setuptools";
      buildInputs = commonBuildInputs ++ [

      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.lib; {
        homepage = "https://github.com/sivel/speedtest-cli";
        license = licenses.asl20;
        description = "Command line interface for testing internet bandwidth using speedtest.net";
      };
    };
  };
  localOverridesFile = ./requirements_override.nix;
  localOverrides = import localOverridesFile { inherit pkgs python; };
  commonOverrides = [
        (let src = pkgs.fetchFromGitHub { owner = "nix-community"; repo = "pypi2nix-overrides"; rev = "90e891e83ffd9e55917c48d24624454620d112f0"; sha256 = "0cl1r3sxibgn1ks9xyf5n3rdawq4hlcw4n6xfhg3s1kknz54jp9y"; } ; in import "${src}/overrides.nix" { inherit pkgs python; })
  ];
  paramOverrides = [
    (overrides { inherit pkgs python; })
  ];
  allOverrides =
    (if (builtins.pathExists localOverridesFile)
     then [localOverrides] else [] ) ++ commonOverrides ++ paramOverrides;

in python.withPackages
   (fix' (pkgs.lib.fold
            extends
            generated
            allOverrides
         )
   )
