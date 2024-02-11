# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./smb.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.forceImportRoot = false;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking = {
    hostId = "8425e349"; 	
    hostName = "lab";
#      domain = "int.eleet.ch";
 #     dhcpcd.enable = false;
#      interfaces.enp2s0.ipv4.addresses = [{
 #       address = "192.168.1.32";
  #      prefixLength = 28;
   #   }];
#      vlans = {
#        vlan100 = { id=100; interface="enp2s0"; };
#        vlan101 = { id=101; interface="enp2s0"; };
#      };
#      interfaces.vlan100.ipv4.addresses = [{
#        address = "10.1.1.2";
#        prefixLength = 24;
#      }];
#      interfaces.vlan101.ipv4.addresses = [{
#        address = "10.10.10.3";
#        prefixLength = 24;
#      }];
 #     defaultGateway = "192.168.1.1";
  #    nameservers = [ "192.168.1.1" ];
};

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
#  i18n.defaultLocale = "de_CH.UTF-8";
console.keyMap = "sg";

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.n3utrino = {
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDnhwXlQtV4N8ZThRyydy2Mrq9Y9ZiwBy9He3JMLSRiyt9+abgevqI5AKpmcU1QSFZUDlH6aIDxJIpAJWLHvpAnNs0xVkDGDUm+2w6xMt7BhCICeX3aMyf0byboZez5HNiDyU/YzlUbpWEgLspMtJ3mC74H62/VeGnvLgKHj5AIYg6wiUXU6ao1JFgJIyKYfHtsMiiqPI34d0liFiCPy0h0zkJ/zAKKlYdGChbdrLPoufKbG7bqKR6+9Za8N4/LjEN9b4uE06o8ugB93Qg/WTU1v5r0jUwsvUTQY3Dz4vRJv02GJSAa48EKgY5bFLdJIkCUeVeu18d0GrDW8VWkm1sVxG5hTDL1c0R/a0KI63AmoLp4ebHDuXA3iBQpk/YiGSEP0iwJU8a9rsm/o0L58J5lQARsvNo4xmw18VK0jvmshyFwpUesWcZ3L7rxuuNBPPHPABVP4ypceiADo4+BvrMWlBMdodNxicX586J9EdilRwhuavS5/fctGqsImuhj1FU2x51rYQVRqP0F88guHt6jwhTFI46GEFChb1JhLLL0zlMdhMhHLJWAaeQ+kLBtHHjE9vTyBqbYA1TTp1NmxivFV3tL/lZEi39mzgWtLSZ7rUYM0s0kWp8Q31m5aOIBDz6Cz1Oc08F8SiTE2YRzhnWexlODg35/96SjksfvQhkRzQ== gabe@dehei.me"
    ];
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  virtualisation.docker = {
    storageDriver = "zfs";
    enable = true;
    extraOptions = "--data-root=/mnt/docker/data";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.tailscale.enable = true;
  #services.localtimed.enable = true;
  services.grafana = {
    enable = true;
    settings.server =  {
      domain = "lab.int.eleet.ch";
      http_port = 3000;
      http_addr = "0.0.0.0";
    };
  };

  services.prometheus = {
    enable = true;
    port = 9090;
    exporters =  {
      node =  {
        enable = true;
        enabledCollectors = ["systemd"];
        port = 9091;
      };
    };
    scrapeConfigs = [
      {
        job_name = "lab";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
    ];

  };

  services.loki = {
    enable = true;
    configuration = {
      server.http_listen_port = 3100;
      auth_enabled = false;

      ingester = {
        lifecycler = {
          address = "127.0.0.1";
          ring = {
            kvstore = {
              store = "inmemory";
            };
            replication_factor = 1;
          };
        };
        chunk_idle_period = "1h";
        max_chunk_age = "1h";
        chunk_target_size = 999999;
        chunk_retain_period = "30s";
        max_transfer_retries = 0;
      };

      schema_config = {
        configs = [{
          from = "2022-06-06";
          store = "boltdb-shipper";
          object_store = "filesystem";
          schema = "v11";
          index = {
            prefix = "index_";
            period = "24h";
          };
        }];
      };

      storage_config = {
        boltdb_shipper = {
          active_index_directory = "/var/lib/loki/boltdb-shipper-active";
          cache_location = "/var/lib/loki/boltdb-shipper-cache";
          cache_ttl = "24h";
          shared_store = "filesystem";
        };

        filesystem = {
          directory = "/var/lib/loki/chunks";
        };
      };

      limits_config = {
        reject_old_samples = true;
        reject_old_samples_max_age = "168h";
      };

      chunk_store_config = {
        max_look_back_period = "0s";
      };

      table_manager = {
        retention_deletes_enabled = false;
        retention_period = "0s";
      };

      compactor = {
        working_directory = "/var/lib/loki";
        shared_store = "filesystem";
        compactor_ring = {
          kvstore = {
            store = "inmemory";
          };
        };
      };
    };
  };
  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = 3031;
        grpc_listen_port = 0;
      };
      positions = {
        filename = "/tmp/positions.yaml";
      };
      clients = [{
        url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
      }];
      scrape_configs = [
       # {
       #   job_name =  "syslog";
       #   syslog = {
       #     listen_address = "0.0.0.0:514";
       #     labels.job = "syslog";
       #   };
       #   relabel_configs = [{
       #     source_labels = [ "__syslog_message_hostname" ];
       #     target_label = "host";
       #   }];
       #     
       # }
        {
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = "lab";
            };
          };
          relabel_configs = [{
            source_labels = [ "__journal__systemd_unit" ];
            target_label = "unit";
          }];
        }
      ];
    };
    # extraFlags
  };


  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  environment.systemPackages = with pkgs; [
    docker
    htop
    mqttui
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

