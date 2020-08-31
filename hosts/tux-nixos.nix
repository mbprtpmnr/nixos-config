{ pkgs, config, ... }:

let
  nixos = import <nixos> { config.allowUnfree = true; };

  keepassWithPlugins =
    pkgs.keepass.override { plugins = [ pkgs.keepass-keepasshttp ]; };
in {
  config = {
    profiles.browsing.enable = true;
    profiles.development.enable = true;
    profiles.home-office.enable = true;

    enabledLanguages = [ "elixir" "erlang" "nix" "ocaml" "python" ];

    languages.python.useMS = true;

    programs.emacs.splashScreen = false;

    home.packages =
      [ nixos.insync keepassWithPlugins pkgs.keybase-gui pkgs.minikube ];

    programs.obs-studio.enable = true;

    services = {
      keyleds.enable = true;
      keybase.enable = true;
      kbfs.enable = true;
    };

    systemd.user.services = {
      keybase-gui = {
        Unit = {
          Description = "Keybase GUI";
          Requires = [ "keybase.service" "kbfs.service" ];
          After = [ "keybase.service" "kbfs.service" ];
        };
        Service = {
          ExecStart = "${pkgs.keybase-gui}/share/keybase/Keybase";
          PrivateTmp = true;
          # Slice      = "keybase.slice";
        };
      };
    };
  };
  # environment.pathsToLink = [ "/share/zsh" ];
}
