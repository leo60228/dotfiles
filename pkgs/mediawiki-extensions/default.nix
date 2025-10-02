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
    rev = "3fd9acb48870a04c245a5a074adbba4a41efc851";
    hash = "sha256-r4p5u8AQGuB6ANuHPChjNqxiBqf54JWAXGCMAwNueH4=";
  };
  MobileFrontend = getWMExtension {
    name = "MobileFrontend";
    rev = "fa47ad32e1566e10e97c2f2ecde29c0686e6e0f2";
    hash = "sha256-4Ly7qntP1G4bfq9fagsCePPt9/4j6koCSfRe70EIlG4=";
  };
  OpenGraphMeta = getWMExtension {
    name = "OpenGraphMeta";
    rev = "11db8b6ecfd78fc010ffe8c3f83f71b10c651e3d";
    hash = "sha256-tgg+XY2zaTnqPOGtYL0mRmTUUvp4BpDRetHE1kCLXhU=";
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
    rev = "eb3c8cec4852c8381a860b14bb4bf86e87f8313b";
    hash = "sha256-Y3RJsONwDVVY2jS3br4ap3JQFFutyWY9rLQUzaqUIYw=";
  };
  PortableInfobox = pkgs.fetchFromGitHub {
    owner = "Universal-Omega";
    repo = "PortableInfobox";
    rev = "b700a0c0a1e3a4083ee95601ae041d9c083184c0";
    hash = "sha256-B0TzFtNiPo/WuacvcSQuKBitAfOo5P0qsnJhWpZYN9M=";
  };
}
