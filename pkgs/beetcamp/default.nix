{
  lib,
  fetchFromGitHub,
  python3Packages,
  beets,
  beetsPackages,
  gitUpdater,
}:

python3Packages.buildPythonApplication rec {
  pname = "beets-beetcamp";
  version = "0.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snejus";
    repo = "beetcamp";
    tag = version;
    hash = "sha256-5tcQtvYmXT213mZnzKz2kwE5K22rro++lRF65PjC5X0=";
  };

  nativeBuildInputs = [
    beets
  ];

  build-system = [ python3Packages.poetry-core ];

  dependencies = with python3Packages; [
    pycountry
    httpx
    packaging
  ];

  passthru.updateScript = gitUpdater { };
}
