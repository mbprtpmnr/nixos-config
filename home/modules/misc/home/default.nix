{ config, pkgs, lib, nixpkgs-2105, unstable, self, ... }:
let
  self' = self.packages.x86_64-linux;
in
{
  profiles.base.enable = true;
  fonts.fontconfig.enable = true;

  systemd.user = {
    # sessionVariables = { NIX_PATH = nixPath; };
  };

  xsession.windowManager.awesome.enable = true;

  home = {
    # sessionVariables = { NIX_PATH = nixPath; };

    packages =
      let
        p = pkgs;
        s = self';
      in
      [
        p.cachix
        # nix-prefetch-scripts
        p.nix-review
        p.exercism
        p.tmate
        p.element-desktop
        # p.powershell
        s."dracula/konsole"

        p.fira-code
        p.cascadia-code

        p.lefthook

        (p.writeShellScriptBin "timew" ''
          export TIMEWARRIORDB="${config.home.homeDirectory}/timmelzer@gmail.com/timewarrior"
          exec ${p.timewarrior}/bin/timew "$@"
        '')
      ];

    stateVersion = "20.09";
  };
}
