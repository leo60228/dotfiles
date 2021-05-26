{ lib, stdenv, fetchurl, perl, unzip, glibc, zlib, bzip2, gdk-pixbuf, xorg, glib, fontconfig, freetype, cairo, pango, gtk3, gtk2, ffmpeg, libGL, atk, alsaLib, setJavaClassPath, gcc-unwrapped }:

let
  common = javaVersion:
    let
      graalvmXXX-ce = stdenv.mkDerivation rec {
        pname = "graalvm${javaVersion}-ce";
        version = "21.2.0-dev";
        srcs = [
          (fetchurl {
             url    = "https://github.com/graalvm/graalvm-ce-dev-builds/releases/download/21.2.0-dev-20210514_1938/graalvm-ce-java16-linux-amd64-dev.tar.gz";
             sha256 = "0f8bgn7pbjxrmz67r3gbcmkgrpyl57w6wd1b102i4b5wxvzlnr1s";
          })
          (fetchurl {
             url    = "https://github.com/graalvm/graalvm-ce-dev-builds/releases/download/21.2.0-dev-20210514_1938/native-image-installable-svm-java16-linux-amd64-dev.jar";
             sha256 = "0iz79pnn02bm7zhn0ids8nj15szpqn8m2hv2bw1jgy2b6z4hwhxh";
          })
          (fetchurl {
             url    = "https://github.com/graalvm/graalvm-ce-dev-builds/releases/download/21.2.0-dev-20210514_1938/python-installable-svm-java16-linux-amd64-dev.jar";
             sha256 = "10cmqkszlavv7kr1jqbfnb43glzkcwi3fxamnplnvbj78m698dq2";
          })
          (fetchurl {
             url    = "https://github.com/graalvm/graalvm-ce-dev-builds/releases/download/21.2.0-dev-20210514_1938/r-installable-java16-linux-amd64-dev.jar";
             sha256 = "1kvpz09qz0vv2w49a5z07dnxrj8a7y2gr6rndlicz1ki7bwmn1hl";
          })
          (fetchurl {
             url    = "https://github.com/graalvm/graalvm-ce-dev-builds/releases/download/21.2.0-dev-20210514_1938/ruby-installable-svm-java16-linux-amd64-dev.jar";
             sha256 = "1amizbcanqi71yxrjy4qbial7pc0xv22h376nxvpg3ah7gd5vy0g";
          })
          (fetchurl {
             url    = "https://github.com/graalvm/graalvm-ce-dev-builds/releases/download/21.2.0-dev-20210514_1938/llvm-toolchain-installable-java16-linux-amd64-dev.jar";
             sha256 = "03pz6m0qdjrnfcqzpax5qk5lih9s04gf809maxy967i15058c41g";
          })
        ];
        nativeBuildInputs = [ unzip perl ];
        unpackPhase = ''
          unpack_jar() {
            jar=$1
            unzip -o $jar -d $out
            perl -ne 'use File::Path qw(make_path);
                      use File::Basename qw(dirname);
                      if (/^(.+) = (.+)$/) {
                        make_path dirname("$ENV{out}/$1");
                        system "ln -s $2 $ENV{out}/$1";
                      }' $out/META-INF/symlinks
            perl -ne 'if (/^(.+) = ([r-])([w-])([x-])([r-])([w-])([x-])([r-])([w-])([x-])$/) {
                        my $mode = ($2 eq 'r' ? 0400 : 0) + ($3 eq 'w' ? 0200 : 0) + ($4  eq 'x' ? 0100 : 0) +
                                   ($5 eq 'r' ? 0040 : 0) + ($6 eq 'w' ? 0020 : 0) + ($7  eq 'x' ? 0010 : 0) +
                                   ($8 eq 'r' ? 0004 : 0) + ($9 eq 'w' ? 0002 : 0) + ($10 eq 'x' ? 0001 : 0);
                        chmod $mode, "$ENV{out}/$1";
                      }' $out/META-INF/permissions
            rm -rf $out/META-INF
          }

          mkdir -p $out
          arr=($srcs)
          tar xf ''${arr[0]} -C $out --strip-components=1
          unpack_jar ''${arr[1]}
          unpack_jar ''${arr[2]}
          unpack_jar ''${arr[3]}
          unpack_jar ''${arr[4]}
          unpack_jar ''${arr[5]}
        '';

        installPhase = {
          "8" = ''
            # BUG workaround http://mail.openjdk.java.net/pipermail/graal-dev/2017-December/005141.html
            substituteInPlace $out/jre/lib/security/java.security \
              --replace file:/dev/random    file:/dev/./urandom \
              --replace NativePRNGBlocking  SHA1PRNG

            # provide libraries needed for static compilation
            for f in ${glibc}/lib/* ${glibc.static}/lib/* ${zlib.static}/lib/*; do
              ln -s $f $out/jre/lib/svm/clibraries/linux-amd64/$(basename $f)
            done
          '';
          "16" = ''
            # BUG workaround http://mail.openjdk.java.net/pipermail/graal-dev/2017-December/005141.html
            substituteInPlace $out/conf/security/java.security \
              --replace file:/dev/random    file:/dev/./urandom \
              --replace NativePRNGBlocking  SHA1PRNG

            # provide libraries needed for static compilation
            for f in ${glibc}/lib/* ${glibc.static}/lib/* ${zlib.static}/lib/*; do
              ln -s $f $out/lib/svm/clibraries/linux-amd64/$(basename $f)
            done
           '';
        }.${javaVersion};

        dontStrip = true;

        # copy-paste openjdk's preFixup
        preFixup = ''
          # Set JAVA_HOME automatically.
          mkdir -p $out/nix-support
          cat <<EOF > $out/nix-support/setup-hook
            if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
          EOF
        '';

        postFixup = ''
          rpath="${ {  "8" = "$out/jre/lib/amd64/jli:$out/jre/lib/amd64/server:$out/jre/lib/amd64";
                      "16" = "$out/lib/jli:$out/lib/server:$out/lib";
                    }.${javaVersion}
                 }:${
            lib.strings.makeLibraryPath [ glibc xorg.libXxf86vm xorg.libX11 xorg.libXext xorg.libXtst xorg.libXi xorg.libXrender
                                                 glib zlib bzip2 alsaLib fontconfig freetype pango gtk3 gtk2 cairo gdk-pixbuf atk ffmpeg libGL gcc-unwrapped.lib ]}"

          for f in $(find $out -type f -perm -0100) $(find $out/languages/R/lib -type f -name \*.so); do
            patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)"     "$f" || true
            patchelf --set-rpath   "$(patchelf --print-rpath "$f" || true):$rpath" "$f" || true
          done

          for f in $(find $out -type f -perm -0100); do
            if ldd "$f" | fgrep 'not found'; then echo "in file $f"; fi
          done
        '';

        propagatedBuildInputs = [ setJavaClassPath zlib ]; # $out/bin/native-image needs zlib to build native executables

        doInstallCheck = true;
        installCheckPhase = ''
          echo ${lib.escapeShellArg ''
                   public class HelloWorld {
                     public static void main(String[] args) {
                       System.out.println("Hello World");
                     }
                   }
                 ''} > HelloWorld.java
          $out/bin/javac HelloWorld.java

          # run on JVM with Graal Compiler
          $out/bin/java -XX:+UnlockExperimentalVMOptions -XX:+EnableJVMCI -XX:+UseJVMCICompiler HelloWorld
          $out/bin/java -XX:+UnlockExperimentalVMOptions -XX:+EnableJVMCI -XX:+UseJVMCICompiler HelloWorld | fgrep 'Hello World'

          # Ahead-Of-Time compilation
          $out/bin/native-image --no-server HelloWorld
          ./helloworld
          ./helloworld | fgrep 'Hello World'

          # Ahead-Of-Time compilation with --static
          $out/bin/native-image --no-server --static HelloWorld
          ./helloworld
          ./helloworld | fgrep 'Hello World'
        '';

        passthru.home = graalvmXXX-ce;

        meta = with lib; {
          homepage = "https://www.graalvm.org/";
          description = "High-Performance Polyglot VM";
          license = licenses.unfree;
          maintainers = with maintainers; [ volth hlolli ];
          platforms = [ "x86_64-linux" ];
        };
      };
    in
      graalvmXXX-ce;
in {
  graalvm8-ce  = common  "8";
  graalvm16-ce = common "16";
}
