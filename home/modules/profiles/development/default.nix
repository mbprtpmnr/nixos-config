{ config, pkgs, lib, ... }:
let cfg = config.profiles.development;

in
{
  options.profiles.development = {
    enable = lib.mkEnableOption
      "A profile that enables the system to be used for developing programs";
  };

  config = lib.mkIf cfg.enable {
    programs.emacs = {
      extraPackages = ep: [ ep.magit ];
      extraInit = ''
        ;; prepare magit use from shell
        (require 'magit)
        (global-git-commit-mode)

        ;; let magit autorefresh on file save within emacs
        (add-hook 'after-save-hook 'magit-after-save-refresh-status t)
      '';
    };

    programs.gh.enable = true;
    programs.git = {
      enable = true;

      userName = "Norbert Melzer";
      userEmail = "timmelzer@gmail.com";

      aliases = {
        graph =
          "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold cyan)%h%C(reset) - %C(green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all";
        co = "checkout";
        br = "branch";
        st = "status";
        ps = "push";
        pl = "pull";
        root = "rev-parse --show-toplevel";
      };

      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
      };

      ignores = [
        # IntelliJ files and folders
        ".idea/"
        "*.iml"
        # backupfiles and shadow copies done by editors
        "*~"
        "\\#*\\#"
        ".#*"
        # Elixir language server
        "/.elixir_ls"
        # MyPy Cache
        ".mypy_cache"
        # Visual Studio Code project configuration
        "/.vscode"
        # Result folder for nix builds
        "result"
        "result-*"
        # direnv caches
        ".direnv/"
        # emacs/python stuff
        "flycheck_*.py"
      ];

      includes = [{
        condition = "gitdir:~/cloudseeds/**";
        contents = {
          init.defaultBranch = "master";
          user.email = "norbert.melzer@cloudseeds.de";
        };
      }];
    };

    home.packages = [ pkgs.ripgrep ];
  };
}
