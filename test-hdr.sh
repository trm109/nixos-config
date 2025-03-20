#!/usr/bin/env bash

nix-shell -p vulkan-tools

ENABLE_HDR_WSI=1 vulkaninfo | grep -i hdr
