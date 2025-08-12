{
  description = "RSpec matchers for working with JSON.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      utils,
      treefmt,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        ruby = pkgs.ruby_3_4;
        rubyPackages = pkgs.rubyPackages_3_4;
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            ruby
            rubyPackages.date
            rubyPackages.psych
            rubyPackages.bigdecimal
          ];
        };

        formatter = treefmt.lib.mkWrapper pkgs {
          programs.nixfmt.enable = true;
        };
      }
    );
}
