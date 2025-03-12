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
    rev = "3def77c029ea8d5c74856710f5e231fd2d9185ae";
    hash = "sha256-TFA0CtLiLr6abjmVeu8m89xEI7jMLPJy7AO1kDS3AOY=";
  };
  MobileFrontend = getWMExtension {
    name = "MobileFrontend";
    rev = "aae56d488072b725c8df9126567f1c068bbc4e59";
    hash = "sha256-ZKsDFzC10bwvVm7IQfY+uEzXInPq5WR49C/jVm0jVtk=";
  };
  OpenGraphMeta = getWMExtension {
    name = "OpenGraphMeta";
    rev = "cb990fcea3b7827f02bcc328e367a7b2387a32a3";
    hash = "sha256-GNtsKbyFZDBCvQUhKzN57ShTflvSCFvVXVNnTPYBmOY=";
  };
  TimedMediaHandler = mkMWExtension rec {
    pname = "TimedMediaHandler";
    src = getWMExtension {
      name = pname;
      rev = "5e0454259958af6790c929114e56336b40be8f81";
      hash = "sha256-wCdBbw6FrDE686iEFG2bHvYTGj1amQjLk+OsYUPcNaU=";
    };
    vendorHash = "sha256-4Xfz+qV5qqaAXZamDn2cqpfL6wxrAw3PCWgf9UBOU/c=";
    composerLock = ./TimedMediaHandler.lock;
  };
  Description2 = getWMExtension {
    name = "Description2";
    rev = "50e2aef88053be12a66b617657c414a665e2d38e";
    hash = "sha256-awJ7piKA5k14c2ZRPM/oyWvnVLizAauecYRoCysuwnQ=";
  };
  PortableInfobox = pkgs.fetchFromGitHub {
    owner = "Universal-Omega";
    repo = "PortableInfobox";
    rev = "f5780412fcb25d3981cdc7f2af8f75518d9ee3cb";
    hash = "sha256-Hm1+jzhq+PIx699ICgJM92xt6UW8jko+kxT2icdCDFc=";
  };
}
