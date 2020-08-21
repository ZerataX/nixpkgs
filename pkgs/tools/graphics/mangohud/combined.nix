{ stdenv, pkgs, lib
, libXNVCtrl
}:
let
  mangohud_64 = pkgs.callPackage ./default.nix { libXNVCtrl = libXNVCtrl; };
  mangohud_32 = pkgs.pkgsi686Linux.callPackage ./default.nix { libXNVCtrl = libXNVCtrl; };
in
pkgs.buildEnv rec {
  name = "mangohud-${mangohud_64.version}";

  paths = [
    mangohud_32
  ] ++
  lib.lists.optionals
    stdenv.is64bit
    [ mangohud_64 ]
  ;

  postBuild = ''
    pushd "$out/share/vulkan/implicit_layer.d/"
    substitute ./MangoHud.json ./MangoHud.json.new \
      --replace "${mangohud_32}" "$out"
    mv MangoHud.json.new MangoHud.json
    popd
  '';

  ignoreCollisions = true;

  meta = mangohud_64.meta;
}
