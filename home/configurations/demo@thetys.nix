{ pkgs, nixpkgs-2105, self, ... }:

let
  stable = nixpkgs-2105.legacyPackages.x86_64-linux;
  self' = self.packages.x86_64-linux;
in
{
  config = {
    nixpkgs.allowedUnfree = [ "google-chrome" ];

    activeProfiles = [ "browsing" "development" ];

    enabledLanguages =
      [ "elixir" "go" "lua" "nix" "python" "terraform" ];

    languages.python.useMS = true;

    programs.emacs.splashScreen = false;
    programs.emacs.extraPackages = ep: [ ep.robot-mode ];

    services.gnome-keyring.enable = true;

    home.packages = [
      stable.mysqlWorkbench
      self'.gnucash-de
    ];

    systemd.user.services = {
      imwheel = {
        Unit = {
          Description = "IMWheel";
          Wants = [ "display-manager.service" ];
          After = [ "display-manager.service" ];
        };

        Service = {
          Type = "simple";
          Environment = [ "XAUTHORITY=%h/.Xauthority" ];
          ExecStart = "${pkgs.imwheel}/bin/imwheel -d";
          ExecStop = "${pkgs.procps}/bin/pkill imwheel";

          Restart = "on-failure";
          RestartSec = "10";
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
  };
}
