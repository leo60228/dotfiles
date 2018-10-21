self: super:

{
  hyper = super.hyper.overrideAttrs (oldAttrs: rec {
    version = "2.0.0-canary.11";
    name = "hyper-${version}";
    src = builtins.fetchurl {
      url = "https://github.com/zeit/hyper/releases/download/${version}/hyper_${version}_amd64.deb";
    };
  });
}
