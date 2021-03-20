{ config, lib, pkgs, ... }:

let cfg = config.programs.gc;
in
{
  options.programs.gc = {
    enable = lib.mkEnableOption "enable GC tool";

    maxAge = lib.mkOption {
      type = lib.types.str;
      default = "10d";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "gc" ''
        sudo ${config.nix.package}/bin/nix-collect-garbage --delete-older-than ${config.programs.gc.maxAge} --verbose
      '')
    ];
  };
}
