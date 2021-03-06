/*
   test for example like this
   $ hydra-eval-jobs pkgs/top-level/release-python.nix
*/

{ nixpkgs ? <nixpkgs>
, officialRelease ? false
, # The platforms for which we build Nixpkgs.
  supportedSystems ? [ "x86_64-linux" ]
, subSetName ? "ocamlPackages"
}:

with import "${nixpkgs}/pkgs/top-level/release-lib.nix" {inherit supportedSystems; };
with lib;

let
  onlySelectedSubset = mapAttrs (name: value:
    let res = builtins.tryEval (
      if name  == subSetName then
        packagePlatforms value
      else []
    );
    in if res.success then res.value else []
    );
in (mapTestOn (onlySelectedSubset pkgs))

