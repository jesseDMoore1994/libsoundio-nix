{
  description = "A Flake for libsoundio";
  inputs = {
    libsoundio-src = {
      url = "https://github.com/andrewrk/libsoundio.git";
      type = "git";
      submodules = true;
      flake = false;
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, libsoundio-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      rec {
        packages = flake-utils.lib.flattenTree {
          libsoundio = pkgs.stdenv.mkDerivation {
            pname = "libsoundio";
            version = libsoundio-src.rev;
            src = libsoundio-src;
            buildInputs = [
              pkgs.cmake
              pkgs.alsa-lib
              pkgs.libjack2
              pkgs.libpulseaudio
            ];
            buildPhase = ''
              cmake .
              make
            '';
          };
        };
        defaultPackage = packages.libsoundio;
      }
    );
}
