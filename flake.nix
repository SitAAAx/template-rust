{
  description = "<project-brief-description>";

  inputs.pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, pre-commit-hooks, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      {
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              cargo-check.enable = true;
              clippy.enable = true;
              # convco.enable = true;
              # cspell.enable = true;
              markdownlint.enable = true;
              nixpkgs-fmt.enable = true;
              rustfmt.enable = true;
              taplo.enable = true;
              yamllint.enable = true;
            };
          };
        };
        devShell = nixpkgs.legacyPackages.${system}.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };
      }
    );
}
