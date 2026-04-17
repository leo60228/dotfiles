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
  version = "0.24.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snejus";
    repo = "beetcamp";
    tag = version;
    hash = "sha256-kKFYuTJys4j67+cak2PDmn6z2vNzVitFXIZXy2bClY8=";
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
