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

# restic --repo /run/media/nmelzer/data/restic/repo --verbose=10 backup --exclude=/home/nmelzer/Videos --exclude=/home/nmelzer/.{cache,cabal,cargo,config,emacs.d/{eln-cache,.cache},gem,gradle,hex,kube,local,m2,minikube,minishift,mix,mozilla,npm,opam,rancher,vscode-oss} --exclude=/home/nmelzer/Downloads --exclude=/home/nmelzer/VirtualBox\ VMs --exclude=/home/nmelzer/go/pkg --exclude=_build --exclude=deps --exclude=result --exclude=.elixir_ls --exclude=.ccls-cache --exclude=.direnv -x ~
