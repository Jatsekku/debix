{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      # Set formating for this flake itself
      formatter."${system}" = pkgs.nixfmt-rfc-style;

      devShells."${system}".default = pkgs.mkShell {
        packages = [
          pkgs.shellcheck
          pkgs.shfmt
        ];
      };
    };
}
