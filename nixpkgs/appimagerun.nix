self: super:
{
  appimage-run = super.appimage-run.override {extraPkgs = pkgs: with pkgs; [ (pkgs.writeShellScriptBin "pkexec" ''
    ${sudo}/bin/sudo "$@"
  '') ];};
}
