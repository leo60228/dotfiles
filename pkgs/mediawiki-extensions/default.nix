{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
  fetchFromGitHub ? pkgs.fetchFromGitHub,
  callPackage ? pkgs.callPackage,
}:

let
  getWMExtension = callPackage ./get-wm-extension.nix { };
  mkMWExtension =
    {
      pname,
      src,
      vendorHash,
      composerLock,
      branch ? null,
    }:
    callPackage ./mk-mediawiki-extension.nix {
      inherit
        pname
        src
        vendorHash
        composerLock
        branch
        ;
    };
in
{
  CodeMirror = getWMExtension {
    name = "CodeMirror";
    rev = "8ede4d472a243ba9ae337bce6e82bcc370da143e";
    hash = "sha256-YtLSxwmYR6jBcGI8uBqnqLMtyNrm4VcgEwS4TSrKY+Q=";
  };
  MobileFrontend = getWMExtension {
    name = "MobileFrontend";
    rev = "6c41d8ac39849def7263b27907feec949676c36c";
    hash = "sha256-VovSDIG7/UY1+/40bIYAgkB4bmQkG1msPkpohlorKK8=";
  };
  OpenGraphMeta = getWMExtension {
    name = "OpenGraphMeta";
    rev = "c01f171eb11ba8abd070c376757524b87fba78f3";
    hash = "sha256-pHO8kHGp2Rd7q/pd1D4rf26LwSy2x7sU5Tw/tifqmNQ=";
  };
  TimedMediaHandler = mkMWExtension rec {
    pname = "TimedMediaHandler";
    src = getWMExtension {
      name = pname;
      rev = "ae529cc004a014028b4199bf73a9349e45eb0f18";
      hash = "sha256-Yx0lV+v2JHzu/tnedkCJnrRL7FbkdkBdRyHcHguAiz8=";
    };
    vendorHash = "sha256-AY8prvrSKAr/5i1a8Qu2mzcQm5RcZLeVklD+rNBnie4=";
    composerLock = ./TimedMediaHandler.lock;
  };
  Description2 = getWMExtension {
    name = "Description2";
    rev = "defa8c4fb5f312affac24c306d64dcf4ec577652";
    hash = "sha256-OOjqsVD5EGsgutONQugJ0TTUMKLD70zALBy/Hf6uwbI=";
  };
  PortableInfobox = pkgs.fetchFromGitHub {
    owner = "Universal-Omega";
    repo = "PortableInfobox";
    rev = "b700a0c0a1e3a4083ee95601ae041d9c083184c0";
    hash = "sha256-B0TzFtNiPo/WuacvcSQuKBitAfOo5P0qsnJhWpZYN9M=";
  };
}
