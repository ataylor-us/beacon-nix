{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
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
  services.adguardhome.enable = true;

  fileSystems."/mnt/beacon-backup" = {
    device = "nas.internal:/srv/nfs/beacon-backup";
    fsType = "nfs";
    options = [
      "noauto"
      "x-systemd.automount"
      "x-systemd.mount-timeout=10s"
      "x-systemd.idle-timeout=600"
      "soft"
    ];
  };

  systemd.services.backup-beacon = {
    startAt = "daily";
    path = [
      pkgs.rsync
      pkgs.sqlite
    ];
    script = ''
      rsync -a --delete --exclude 'kuma.db*' /var/lib/uptime-kuma/ /mnt/beacon-backup/uptime-kuma/
      sqlite3 /var/lib/uptime-kuma/kuma.db ".backup /mnt/beacon-backup/uptime-kuma/kuma.db"
      rsync -a --delete /var/lib/AdGuardHome/ /mnt/beacon-backup/AdGuardHome/
    '';
  };

  systemd.tmpfiles.rules = [
    # Disable turbo boost + low power, trying to make this device quieter
    "w /sys/devices/system/cpu/intel_pstate/no_turbo - - - - 1"
    "w /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference - - - - power"
  ];

  services.caddy = {
    enable = true;
    virtualHosts."status.internal".extraConfig = ''
      tls internal
      reverse_proxy 127.0.0.1:3001
    '';
    virtualHosts."dns.internal".extraConfig = ''
      tls internal
      reverse_proxy 127.0.0.1:3000
    '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
    53
  ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  security.sudo.extraConfig = ''
    Defaults pwfeedback
  '';

  users.users.alex = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFKo4XAoO9Z4jjpOndjKMQAtR8IRQHbn7m1WaI53Ynho"
    ];
  };

  programs.nano.enable = false;
  programs.bash.interactiveShellInit = "set -o vi";
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
  environment.shellAliases = {
    sudo = "sudo ";
    view = "nvim -R";
  };

  environment.systemPackages = with pkgs; [
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
