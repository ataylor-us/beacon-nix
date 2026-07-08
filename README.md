# beacon-nix

This is my nix ([NixOS](https://nixos.org/)) config files.

Tentatively, this host is going to host my [Home Assistant VM](https://www.home-assistant.io/installation/linux/), as well as [Uptime-Kuma](https://uptime.kuma.pet/).  It currently resides on a N100 Beelink mini PC.

## Deploying

The nix configuration files are currently symlinked into `~/beacon-nix/`.

```bash
# scp nix file
just deploy
# rebuild
just switch
```
