{
  description = "Ryujinx Canary – always latest x64 AppImage";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      ryubing_meta = pkgs.lib.importJSON ./ryubing_version.json;
      version = ryubing_meta.version;
      hash = ryubing_meta.hash;
    in {
      packages.default = pkgs.appimageTools.wrapType2 {
        name = "ryubing";
        version = "${version}";
        pname = "ryubing";
        src = pkgs.fetchurl {
          url = "https://git.ryujinx.app/Ryubing/Canary/releases/download/${version}/ryujinx-canary-${version}-x64.AppImage";
          hash = hash;
        };
        extraPkgs = pkgs: with pkgs; [icu];
      };
      devShells.default = pkgs.mkShell {
        name = "ryujinx-canary";

        packages = with pkgs; [
          curl
          jq
        ];
      };
    });
}
