deploy:
    scp configuration.nix alex@beacon.internal:beacon-nix/configuration.nix

switch:
    ssh -t alex@beacon.internal 'sudo nixos-rebuild switch'
