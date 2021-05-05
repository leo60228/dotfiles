{ lib, stdenv, requireFile, perl, unzip, glibc, zlib, bzip2, gdk-pixbuf, xorg, glib, fontconfig, freetype, cairo, pango, gtk3, gtk2, ffmpeg, libGL, atk, alsaLib, setJavaClassPath }:

let
  common = javaVersion:
    let
      graalvmXXX-ee = stdenv.mkDerivation rec {
        pname = "graalvm${javaVersion}-ee";
        version = "21.1.0";
        srcs = [
          (requireFile {
             name   = "graalvm-ee-java${javaVersion}-linux-amd64-${version}.tar.gz";
             sha256 = {  "8" = "0nws0kln0hhsp9ai9740lf47qi9ghpndzqfqfc10kax2cnlf4q8p";
                        "16" = "0km75axdjw5kgrv865g2c9v14154z03lwrwdavzwvm0gqfgbnm0a";
                      }.${javaVersion};
             url    = "https://www.oracle.com/technetwork/graalvm/downloads/index.html";
          })
          (requireFile {
             name   = "native-image-installable-svm-svmee-java${javaVersion}-linux-amd64-${version}.jar";
             sha256 = {  "8" = "1hvgf9ir3z544jwswp1d8s61w4w5sa1sr92yqjbkxn6hyc6zd2w4";
                        "16" = "0nikrz2kxb5pb5877qjm0qjchb58jgz3flksxbbjvccy29hnvzw0";
                      }.${javaVersion};
             url    = "https://www.oracle.com/technetwork/graalvm/downloads/index.html";
          })
          (requireFile {
             name   = "llvm-toolchain-installable-java${javaVersion}-linux-amd64-${version}.jar";
             sha256 = {  "8" = "19hnjpkz4wxjpxbglap0vzcsjllc1091ams4raca7n4g9fcn88mz";
                        "16" = "1ndg16xh93zs8i6s6naylhy5p1nnqvjib67lfjf3n7232g79jn2z";
                      }.${javaVersion};
             url    = "https://www.oracle.com/technetwork/graalvm/downloads/index.html";
          })
          (requireFile {
             name   = "wasm-installable-svm-svmee-java${javaVersion}-linux-amd64-${version}.jar";
             sha256 = {  "8" = "0jjm5yajkvvz0mh1mh4synvll8p6niwa0g9z2qwjhlfjscykn16a";
                        "16" = "0652jdz9yn1h27p998j05kvzpd7gs1dqprmd0ywxm3n4kqp5a9w8";
                      }.${javaVersion};
             url    = "https://www.oracle.com/technetwork/graalvm/downloads/index.html";
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
                                                 glib zlib bzip2 alsaLib fontconfig freetype pango gtk3 gtk2 cairo gdk-pixbuf atk ffmpeg libGL ]}"

          for f in $(find $out -type f -perm -0100); do
            patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$f" || true
            patchelf --set-rpath   "$rpath"                                    "$f" || true
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

        passthru.home = graalvmXXX-ee;

        meta = with lib; {
          homepage = "https://www.graalvm.org/";
          description = "High-Performance Polyglot VM";
          license = licenses.unfree;
          maintainers = with maintainers; [ volth hlolli ];
          platforms = [ "x86_64-linux" ];
        };
      };
    in
      graalvmXXX-ee;
in {
  graalvm8-ee  = common  "8";
  graalvm16-ee = common "16";
}
