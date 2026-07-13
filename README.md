# beacon-nix

This is my nix ([NixOS](https://nixos.org/)) config.

Currently, this box (a Beelink Mini EQ12, N100) hosts an instance of [Uptime-Kuma](https://uptime.kuma.pet/).

Home Assistant lives on a HAOS [VM](https://www.home-assistant.io/installation/linux/), using KVM (via libvirt) as the hypervisor. The VM uses a separate physical port for the bridge.

The hard drive is encrypted by LUKS, with the key loaded from a flash drive attached to it during boot.

## Deploying

The nix configuration files are currently symlinked into `~/beacon-nix/`.

```bash
# scp nix file & rebuild
just
```
