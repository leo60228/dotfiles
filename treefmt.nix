{ pkgs, ... }:
{
  projectRootFile = "flake.nix";

  programs.nixfmt.enable = true;
  programs.yamlfmt.enable = true;
  programs.jsonfmt.enable = true;

  programs.shfmt = {
    enable = true;
    indent_size = 4;
  };
  settings.formatter.shfmt.options = [
    "--space-redirects"
    "--case-indent"
    "--language-dialect=bash"
  ];

  programs.mdformat = {
    enable = true;
    package = pkgs.mdformat.withPlugins (p: [ p.mdformat-gfm ]);
  };

  settings.formatter.shfmt.includes = [
    "scripts/*"
    "pkgs/bin/$"
    "pkgs/bin/ahorn"
    "pkgs/bin/all-static-gcc"
    "pkgs/bin/celeste"
    "pkgs/bin/chln"
    "pkgs/bin/copy-screenshot"
    "pkgs/bin/crops"
    "pkgs/bin/devkita64"
    "pkgs/bin/elixiremanager"
    "pkgs/bin/elixireshorten"
    "pkgs/bin/git-update-fork"
    "pkgs/bin/herolab"
    "pkgs/bin/make_fcp_x3g"
    "pkgs/bin/mounthdd"
    "pkgs/bin/nspawn"
    "pkgs/bin/run_scaled"
    "pkgs/bin/tasmota"
    "pkgs/bin/vim"
  ];

  settings.global.excludes = [
    "LICENSE"
    ".git-blame-ignore-revs"
  ];
}
