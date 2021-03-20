{ nixpkgs, self, ... }@inputs:
let
  inherit (nixpkgs.lib) nixosSystem;

  mkSystem = name: nixpkgs: modules:
    nixpkgs.lib.nixosSystem ({
      extraArgs = inputs;

      system = "x86_64-linux";

      modules = [
        (./. + "/legacy/${name}.nix")
        (./. + "/hardware/${name}.nix")
        nixpkgs.nixosModules.notDetected
        self.nixosModule
      ] ++ modules;
    });
in
{
  delly-nixos = mkSystem "delly-nixos" nixpkgs (with self.nixosModules; [ version ]);
  tux-nixos = mkSystem "tux-nixos" nixpkgs (with self.nixosModules; [ intel version ]);
  nixos = mkSystem "nixos" inputs.unstable (with self.nixosModules; [ virtualbox-demo version ]);
}
