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
  version = "0.23.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snejus";
    repo = "beetcamp";
    tag = version;
    hash = "sha256-8FEDpobEGZ0Lw1+JRoFIEe3AuiuX7dwsRab+P3hC3W0=";
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
