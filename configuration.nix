# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ]; # for postgres

  nix.gc.automatic = true;
  nix.gc.dates = "03:15";

  environment.systemPackages = [
# pkgs.gcc
  pkgs.emacs24-nox
  pkgs.git
  pkgs.htop
  pkgs.iotop
# pkgs.nix this should be automatic, no?
  pkgs.sbt
  pkgs.tmux
  pkgs.activator
#  pkgs.certbot # this is not in 16.03
 # pkgs.altcoins.bitcoin
   pkgs.jdk
#   pkgs.goaccess   # 1.0 in not in 16.03
  ] ;
  
  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
   time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # environment.systemPackages = with pkgs; [
  #   wget
  # ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

   services.postgresql.enable = true;
   services.postgresql.package = pkgs.postgresql94;
   services.postgresql.extraConfig = ''
                                   shared_buffers = 8GB
                                   effective_cache_size = 24GB
                                   work_mem = 128MB
                                   maintenance_work_mem = 8GB
                                   random_page_cost = 1.5
                                   effective_io_concurrency = 5
                                   checkpoint_segments=32
                                   checkpoint_completion_target=0.9
                                   '';

   services.nginx.enable = true;
   services.nginx.config = pkgs.lib.readFile /nixos/nginx.conf;

   networking.firewall.allowedTCPPorts = [22 80 443 8333 7890 8080 8081 9000 9001];
   networking.firewall.allowPing = true; 

   services.cron.enable = true;
   services.cron.systemCronJobs = 
   [ ''@weekly  root   certbot renew --standalone --pre-hook "systemctl stop nginx" --post-hook "systemctl start nginx"''
#    ''@hourly  root   goaccess -p /root/.goaccessrc -f /var/spool/nginx/logs/access.log -o /data/www/report.html'' # we can do this in realtime now!
                    ] ;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };/

  security.sudo.wheelNeedsPassword = false;

  services.openssh.authorizedKeysFiles = ["/root/.ssh/authorized_keys" "/nixos/authorized_keys"];

  users.extraUsers.stefan =
      { createHome      = true;
            home            = "/home/stefan";
	          description     = "your name";
		        extraGroups     = [ "wheel" ];
			      useDefaultShell = true;
			            openssh.authorizedKeys.keys = [
				            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCiAlE0jX4sWsQTaCn6XFCLkafAnfrEOkzRCyysM/j+QFwdsc2tBaTHIoiy32jV+WmUrpTxytwDzr9IxO5ncP3nFZklDxBwF/Edt6GFn8YuTPfyvYEqbTgeuSGlpceT3MYiyLnOJvtzEdJoBkiHCWgRaDriMCTRXrHT91YehEO/sYCY+EIUAQe2VlyKQY3Owt26fWRMvPzf8oSBA/YKvxQ3ORo3X8ZZ9AsFNqm3OR0FeSz0ADvi7rZr4us+H9yuIbFZnwj3mOUnrWhNL3sDi1PD7DePlJyqjXMc1I6DJdYbssV2UZGz4rcVnp6vOIAL/NBo5QuqVdZYICeVeCbSR55 yzark@yzark-Aspire-5750G"
					          ];
						      };
  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

   nix.buildCores = 0;

# this makes building maximally parallel. disable if something goes wrong!
}
