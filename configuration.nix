{ config, pkgs, ... }:

{
  imports = [ <nixos/modules/virtualisation/docker-image.nix> ];
  
  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql94;
  
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ]; # for postgres

  nix.gc.automatic = true;
  nix.gc.dates = "03:15";

  environment.systemPackages = [
  pkgs.emacs
  pkgs.bitcoind
  pkgs.emacs-nox
  pkgs.git
  pkgs.htop
  pkgs.iotop
  pkgs.nix
  pkgs.sbt
  pkgs.tmux
  ] ;
}

