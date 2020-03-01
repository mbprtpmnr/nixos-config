{ config, lib, pkgs, ... }:

let cfg = config.languages.elixir;

in {
  options.languages.elixir = {
    enable = lib.mkEnableOption "Enable support for elixir language";
  };

  config = lib.mkIf cfg.enable {
    programs.emacs.extraPackages = ep: [ ep.eglot ep.elixir-mode ep.company ];

    programs.emacs.extraConfig = ''
      ;; Confire elixir related stuff
      (require 'eglot)
      (add-to-list 'eglot-server-programs
                   '(elixir-mode . ("sh" "/home/nmelzer/.elixir-ls/release/language_server.sh")))

      (add-hook 'elixir-mode-hook
                (lambda ()
                  (subword-mode)
                  (eglot-ensure)
                  (company-mode)
                  (flymake-mode)
                  (add-hook 'before-save-hook 'eglot-format nil t)))
    '';
  };
}
