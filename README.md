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
