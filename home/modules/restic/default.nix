{ config, lib, pkgs, ... }:
let
  cfg = config.services.restic;
in
{
  options.services.restic = {
    enable = lib.mkEnableOption "restic backup service";

    package = lib.mkOption {
      type = lib.types.pacakge;
      default = pkgs.restic;
    };

    excludes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "${config.home.homeDirectory}/.cache" ];
    };
  };
}
