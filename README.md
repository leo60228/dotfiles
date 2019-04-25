# My NixOS Configuration
My NixOS setup.

## Architecture
### `./lib/`
- `./lib/componentize.nix`: WIP component system. A component is a self-contained module, designed to require as little typing as possible. Currently just an experiment. Will write an article on this system soon.
- `./lib/makeComponent.nix`: Used in the creation of a component.
- `./lib/getSystemConfig.nix`: A function taking a system name that generates a NixOS module that imports all NixOS modules necessary for the system name, currently `hardware/${name}.nix` and `system/${name}.nix`. 
- `./lib/firstLine.nix`: Get the first line of a multiline string. Currently unused.

### `./hardware/`
- `./hardware/*.nix`: Hardware configuration for each system.

### `./systems/`
- `./systems/laptop.nix`: Software configuration for my laptop.

### `./modules/`
- `./modules/base.nix`: Base NixOS module, imported on all systems.
- `./modules/componentBase.nix`: Root component module.

### `./components/`
- `./components/en_us.nix`: English internationalization settings.
- `./components/vfio.nix`: VFIO VM requirements.
- `./components/kde.nix`: KDE Plasma 5 + SDDM
- `./components/default.nix`: Calls componentize on all components.
- `./components/docker.nix`: Docker daemon
- `./components/gui.nix`: GUI basics
- `./components/est.nix`: ET timezone
- `./components/extra.nix`: Extra basic packages
- `./components/steam.nix`: Steam
- `./components/component.nix`: Empty component
- `./components/efi.nix`: EFI bootloader

### `.`
- `./default.nix`: A file that is an "automatically-generated" index of all systems, and the (currently unwritten) NixOps configuration.
- `./rawConfig.nix`: A file that is the NixOS configuration for my laptop. Used due to the NixOps setup being unwritten, and will be deleted.