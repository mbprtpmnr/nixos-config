{ self, nixpkgs, ... }:

{
  system = "x86_64-linux";

  modules =
    (with self.nixosModules; [ cachix flake intel k3s packet-iscsi ]) ++ [
      ./legacy/tux-nixos.nix

      ./hardware/tux-nixos.nix
      nixpkgs.nixosModules.notDetected
    ];
}
