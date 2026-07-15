{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.blacklistedKernelModules = [
    "iwlwifi"
    "btusb"
    "bluetooth"
  ];

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
  services.openssh.settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
    PermitRootLogin = "no";
  };
  services.fstrim.enable = true;
  services.fail2ban.enable = true;
  services.uptime-kuma.enable = true;

  fileSystems."/mnt/uptimekuma-backup" = {
    device = "nas.internal:/srv/nfs/uptimekuma-backup";
    fsType = "nfs";
    options = [
      "noauto"
      "x-systemd.automount"
      "x-systemd.mount-timeout=10s"
      "x-systemd.idle-timeout=600"
      "soft"
    ];
  };

  systemd.services.backup-uptime-kuma = {
    startAt = "daily";
    path = [ pkgs.sqlite ];
    script = ''
      sqlite3 /var/lib/uptime-kuma/kuma.db ".backup /var/lib/uptime-kuma/kuma.db.bak"
      cp /var/lib/uptime-kuma/kuma.db.bak /mnt/uptimekuma-backup/kuma.db
    '';
  };

  services.caddy = {
    enable = true;
    virtualHosts."status.internal".extraConfig = ''
      tls internal
      reverse_proxy 127.0.0.1:3001
    '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  virtualisation.libvirtd = {
    enable = true;
    onShutdown = "shutdown";
    onBoot = "ignore";
  };
  systemd.services.libvirtd = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };

  networking.bridges.br0.interfaces = [ "enp1s0" ];
  networking.networkmanager.unmanaged = [
    "interface-name:enp1s0"
    "interface-name:br0"
  ];

  security.sudo.extraConfig = ''
    Defaults pwfeedback
  '';

  users.users.alex = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFKo4XAoO9Z4jjpOndjKMQAtR8IRQHbn7m1WaI53Ynho"
    ];
  };

  programs.nano.enable = false;
  environment.variables.EDITOR = "nvim";
  environment.shellAliases = {
    sudo = "sudo ";
    vi = "nvim";
    vim = "nvim";
    view = "nvim -R";
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
    htop
    procps
    screen
    tmux
    curl
    wget
    rsync
  ];

  system.stateVersion = "26.05";
}
