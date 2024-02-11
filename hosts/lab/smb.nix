
{ config, lib, pkgs, ... }:{
 services.samba.openFirewall = true;
 services.samba-wsdd = {
  # make shares visible for windows 10 clients
  enable = true;
  openFirewall = true;
};
services.samba = {
  enable = true;
  securityType = "user";
  extraConfig = ''
    workgroup = WORKGROUP
    server string = lab
    netbios name = lab
    security = user 
    #use sendfile = yes
    #max protocol = smb2
    # note: localhost is the ipv6 localhost ::1
    hosts allow = 192.168.1. 127.0.0.1 localhost
    hosts deny = 0.0.0.0/0
    guest account = nobody
    map to guest = bad user
  '';
  shares = {
    scans = {
      path = "/mnt/smb_shares/docs";
      browseable = "yes";
      "read only" = "no";
      "guest ok" = "yes";
      "create mask" = "0644";
      "directory mask" = "0755";
      "force user" = "n3utrino";
      "force group" = "users";
    };
    #private = {
    #  path = "/mnt/Shares/Private";
    #  browseable = "yes";
    #  "read only" = "no";
    #  "guest ok" = "no";
    #"create mask" = "0644";
    #  "directory mask" = "0755";
    #  "force user" = "username";
    #  "force group" = "groupname";
    #};
  };
}; 

}
