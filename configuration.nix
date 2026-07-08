{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.kernelModules = [ "usb_storage" ];
  boot.initrd.luks.devices.cryptroot = {
    device = "/dev/nvme0n1p2";
    allowDiscards = true;
    keyFile = "/dev/disk/by-id/usb-SanDisk_Cruzer_Blade_200435142011C0D082FA-0:0";
    keyFileSize = 4096;
    keyFileTimeout = 5;
  };

  networking.hostName = "beacon";
  networking.domain = "internal";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  services.openssh.enable = true;
  services.fstrim.enable = true;
  services.fail2ban.enable = true;
  services.uptime-kuma.enable = true;

  services.caddy = {
    enable = true;
    virtualHosts."beacon.internal".extraConfig = ''
      tls internal
      reverse_proxy 127.0.0.1:3001
    '';
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  users.users.alex = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFKo4XAoO9Z4jjpOndjKMQAtR8IRQHbn7m1WaI53Ynho"
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
    htop
  ];

  system.stateVersion = "26.05";
}
