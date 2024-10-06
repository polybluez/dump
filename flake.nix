{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    rust-overlay,
  }:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
        lib = pkgs.lib;
        verilator_git = pkgs.verilator.overrideAttrs (prev: {
          version = "5.028";
          doCheck = false;
          src = pkgs.fetchFromGitHub {
            owner = "verilator";
            repo = "verilator";
            rev = "bc8a332ee8874262a54e68dd861bbb7554f3630f";
            hash = "sha256-7mAGc8y2fijZR1cyrjovkggZm4PcG1FLxJrwTqJg3Ak="; # lib.fakeHash
          };
        });
        sv-lang_git = pkgs.sv-lang.overrideAttrs (prev: rec {
          version = "7.0";
          doCheck = false;
          enableParallelBuilding = true;
          buildInputs = [pkgs.boost pkgs.fmt_11 pkgs.mimalloc];
          src = pkgs.fetchFromGitHub {
            owner = "MikePopoloski";
            repo = "slang";
            rev = "2ba4087145919a58ba1221577403c134e7b48e58";
            hash = "sha256-9a5s7CTGVZ/p4KeNN7MPR6ZEw16jUkiEdNcESVxV/kk=";
          };
        });
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            alejandra # nix formatter
            dart
            antlr
            verilator_git
            sv-lang_git
          ];
        };
      }
    );
}
