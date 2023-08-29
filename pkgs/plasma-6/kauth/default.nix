{
  lib, stdenv, fetchFromGitLab, writeScript,
  extra-cmake-modules, kcoreaddons, qttools
}:

stdenv.mkDerivation rec {
  pname = "kauth";
  version = "unstable-2023-08-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "frameworks";
    repo = pname;
    rev = "86e8c4f20003a19d5f69549c4b1fb7097a5eaf8f";
    sha256 = "dCWxWAKT3FQOYu2615wQkEW4sfVYXFL8OUkEm53Ucac=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools ];
  propagatedBuildInputs = [ kcoreaddons ];
  patches = [
    ./cmake-install-paths.patch
  ];
  # library stores reference to plugin path,
  # separating $out from $bin would create a reference cycle
  outputs = [ "out" "dev" ];
  setupHook = writeScript "setup-hook" ''
    if [ "''${hookName:-}" != postHook ]; then
        postHooks+=("source @dev@/nix-support/setup-hook")
    else
        # Propagate $dev so that this setup hook is propagated
        # But only if there is a separate $dev output
        if [ "''${outputDev:?}" != out ]; then
            propagatedBuildInputs="''${propagatedBuildInputs-} @dev@"
        fi
    fi
  '';
}
