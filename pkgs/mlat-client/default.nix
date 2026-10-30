{
  fetchFromGitHub,
  unstableGitUpdater,
  buildPythonApplication,
  setuptools,
  pyasyncore,
}:

buildPythonApplication {
  pname = "mlat-client";
  version = "0.4.2-unstable-2026-03-31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wiedehopf";
    repo = "mlat-client";
    rev = "28ae4f7409c9dfddd2bb8984baadce5d31fdc8e3";
    hash = "sha256-YFYm6TPMwEfeP/AOkNB1pz5TeF9628OmdxDySJVIqHg=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyasyncore ];

  passthru.updateScript = unstableGitUpdater { };

  meta.mainProgram = "mlat-client";
}
