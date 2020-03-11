#!/usr/bin/env bash
# Entrypoint wrappers
# includes all entrypoint scripts

set -e

# Read secrets for ClusterControls and convert into env variables
source /cc-secrets.sh

# ClusterControl entrypint
source /cc-entrypoint.sh

# kartoza/postgis entrypoint
source /docker-entrypoint.sh