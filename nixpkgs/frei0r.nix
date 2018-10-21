self: super:
{
  frei0r = self.runCommand "frei0r" { } ''
    mkdir -p $out/usr/lib/
    cp -r ${super.frei0r}/* $out/
    ln -s ${super.frei0r}/lib/frei0r-1 $out/usr/lib/frei0r-1
  '';
}
