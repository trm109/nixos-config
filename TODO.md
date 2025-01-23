# NixOS config related todo list.
- Make hardware agnostic.
    - Hostnames become presets rather than references to specific machines (i.e. abstract hardware uuids)
- Automatic documentation generation.
- Automatic flake update for unstable packages.
- Start using home manager
    - Create a flake lib for symlinking from `/etc/nixos/*/program_name/dot-config-name/ -> ~/.dot-config-name/`
        - Initialize individual program dot-configs as git submodules.
            - .gitignore presets for things like `fish` where if you clone onto another machine, it becomes very upset.