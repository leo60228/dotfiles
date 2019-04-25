{pkgs ? import <nixpkgs> {}, version ? "10"}:                                                                                                                                                
if version == "06" then import ./julia-wrapped.nix {                                                                                                                                          
  inherit pkgs;                                                                                                                                                                               
  juliapkg = (import ./julia-nixpkgs.nix).julia_06;                                                                                                                                           
} else import ./julia-wrapped.nix {                                                                                                                                                           
  inherit pkgs;                                                                                                                                                                               
  juliapkg = pkgs."julia_${version}";                                                                                                                                                         
}                                                                                                                                                                                             
