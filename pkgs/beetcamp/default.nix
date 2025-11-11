{
  fetchFromGitHub,
  beets-minimal,
  gitUpdater,
  buildPythonApplication,
  poetry-core,
  pycountry,
  httpx,
  packaging,
}:

buildPythonApplication rec {
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
    beets-minimal
  ];

  build-system = [ poetry-core ];

  dependencies = [
    pycountry
    httpx
    packaging
  ];

  passthru.updateScript = gitUpdater { };
}
