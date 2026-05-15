#!/usr/bin/env bash
# Kodra macOS — Install Trivy (container & IaC security scanner)
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

brew_install trivy
