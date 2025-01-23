# My personal NixOS config
Flakes based, very minimal Home-Manager implementation.

## General Structure
├── hosts # Folder holding configs for specific devices.
│   ├── asus-flow # My Asus Nvidia Tablet Gaming Laptop (Asus Flow x16 2022). Has some Nvidia config overrides.
│   └── viceroy # My pure AMD desktop.
├── modules # Anything that isn't user or host related
│   ├── hardware # Hardware configs for things like audio, gpu drivers, etc. Includes some mkEnableOption settings for Nvidia.
│   ├── software # Includes anything not related to Nix or the Firmware. Anything from Minecraft to Neovim.
│   └── system # Linux and Nix configs. Things like Locale, fonts, boot settings.
└── users # My user configs. Has my gf <3 and I

## Devenv
I use Devenv.sh for all of my dev environment needs, including my NixOS Config.
If you don't care about devenv, ignore all `devenv*` and `.envrc` files.

## Questions/Concerns/Advice
Submit an issue! I'll be more than happy to take a look.
