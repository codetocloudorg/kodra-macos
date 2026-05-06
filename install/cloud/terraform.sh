#!/usr/bin/env bash
# Kodra macOS — Install Terraform
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

brew tap hashicorp/tap 2>/dev/null || true
brew_install hashicorp/tap/terraform
