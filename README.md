# beacon-nix

This is my Nix ([NixOS](https://nixos.org/)) config for my "beacon" box, which hosts essential services for my home.

Currently, this box (a Beelink Mini EQ12, N100) hosts an instance of [Uptime-Kuma](https://uptime.kuma.pet/) and an [AdGuardHome](https://github.com/AdguardTeam/AdGuardHome) instance.

This AdGuardHome instance is used as a custom DNS server for some of my devices at home.

The hard drive is encrypted by LUKS, with the key loaded from a flash drive attached to it during boot.

## Deploying

The nix configuration files are currently symlinked into `~/beacon-nix/`.

```bash
# scp nix file & rebuild
just
```

## Fan curve

This machine is in my living room and I want it to be as quiet as possible, had to play around with the fan curve.

This was set in the BIOS under Advanced -> CPU Smart Fan Mode (Automatic Mode).

| Setting                          | Value |
| -------------------------------- | ----- |
| Fan off temperature limit        | 20    |
| Fan start temperature limit      | 25    |
| Fan full speed temperature limit | 85    |
| Fan start PWM                    | 40    |
| PWM slope setting                | 1 PWM |
