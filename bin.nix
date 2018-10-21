pkgs: pkgs.runCommand "leobin" {} ''
  mkdir -p $out/bin
  cp -r ${./bin}/* $out/bin
''
