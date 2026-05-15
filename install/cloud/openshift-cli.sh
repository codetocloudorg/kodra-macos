#!/usr/bin/env bash
# Kodra macOS — Install OpenShift CLI (oc) for Red Hat OpenShift
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

brew_install openshift-cli
