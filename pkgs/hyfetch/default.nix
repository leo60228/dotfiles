{
  lib,
  fetchFromGitHub,
  python3,
  unstableGitUpdater,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "hyfetch";
  version = "2.0.4-unstable-2025-10-22";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hykilpikonna";
    repo = "hyfetch";
    rev = "2252fc36e76eebc42030c383784f63f9489f5630";
    hash = "sha256-ffmaT33alz3KV3vxGI5uM8hBerCD48SXP9ZopWcXolo=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    typing-extensions
    setuptools
  ];

  # No test available
  doCheck = false;

  pythonImportsCheck = [
    "hyfetch"
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "neofetch with pride flags <3";
    longDescription = ''
      HyFetch is a command-line system information tool fork of neofetch.
      HyFetch displays information about your system next to your OS logo
      in ASCII representation. The ASCII representation is then colored in
      the pattern of the pride flag of your choice. The main purpose of
      HyFetch is to be used in screenshots to show other users what
      operating system or distribution you are running, what theme or
      icon set you are using, etc.
    '';
    homepage = "https://github.com/hykilpikonna/HyFetch";
    license = licenses.mit;
    mainProgram = "hyfetch";
  };
}
