# My personal NixOS config
Flakes based, very minimal Home-Manager implementation.

## General Structure
### Hosts (Machine-specific configs)
### Modules (Groups of 'capabilities' organized arbitrarily)
#### Applications
Things that humans will run.
##### Desktop
Desktop-specific definitions. Things that only make sense in the context of a specific Desktop Environment.
#### Firmware
Software needed for specific hardware. Things like Nvidia drivers.
Should NOT contain derivations that enable things, just definitions for IF they are enabled.
#### Services
Things that run in the background, and are NOT run by humans. Network manager, Bluetooth, daemons, etc.
### Users (User specific configs)
### Pkgs (custom defined package definitions or overrides)

## Devenv
I use Devenv.sh for all of my dev environment needs, including my NixOS Config.
If you don't care about devenv, ignore all `devenv*` and `.envrc` files.

## Questions/Concerns/Advice
Submit an issue! I'll be more than happy to take a look.
