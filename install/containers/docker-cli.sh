#!/usr/bin/env bash
# Kodra macOS — Install Docker CLI + Compose (no Docker Desktop)
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

brew_install docker
brew_install docker-compose
brew_install docker-credential-helper

# Link docker-compose as a Docker CLI plugin
mkdir -p "$HOME/.docker/cli-plugins"
ln -sfn "$(brew --prefix)/opt/docker-compose/bin/docker-compose" \
    "$HOME/.docker/cli-plugins/docker-compose"
