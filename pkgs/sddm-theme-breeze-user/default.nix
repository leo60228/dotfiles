{ runCommandNoCC, plasma-desktop }:

runCommandNoCC "sddm-theme-breeze-user" { } ''
  mkdir -p $out/share/sddm/themes
  cp -r ${plasma-desktop}/share/sddm/themes/breeze $out/share/sddm/themes/breeze-user
  chmod -R u+w $out
  sed -i -z '/WallpaperFader {[^}]*}/,''${s///;b};$q1' $out/share/sddm/themes/breeze-user/Main.qml
  substituteInPlace $out/share/sddm/themes/breeze-user/Background.qml --replace-fail 'fillMode: Image.PreserveAspectCrop' 'fillMode: Image.PreserveAspectCrop; horizontalAlignment: Image.AlignLeft'
  substituteInPlace $out/share/sddm/themes/breeze-user/metadata.desktop --replace-fail 'Name=Breeze' 'Name=Breeze (user)' --replace-fail 'Theme-Id=breeze' 'Theme-Id=breeze-user'
  cat > $out/share/sddm/themes/breeze-user/theme.conf.user << EOF
  [General]
  background = ${./my_burden_is_light.png}
  EOF
''
