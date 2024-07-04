{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libsass,
  pythonRelaxDepsHook,
}:

buildPythonPackage rec {
  pname = "qtsass";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "spyder-ide";
    repo = pname;
    rev = "v${version}";
    sha256 = "LzLTI22rE/mrzAjBHMDgWfa2Cdm/KP76D8QJvxyMbeo=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  propagatedBuildInputs = [ libsass ];

  pythonRelaxDeps = [ "libsass" ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/spyder-ide/qtsass";
    description = "Compile SASS files to Qt stylesheets";
    license = licenses.mit;
    maintainers = with maintainers; [ leo60228 ];
  };
}
