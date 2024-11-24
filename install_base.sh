#!/usr/bin/bash

# Exit bash immediately if any command has a non-zero return code
set -o errexit

# Treat unset variables as an erorr
set -o nounset

# Do not mask errror in pipes
set -o pipefail

# Instruct apt-get that it's run unnder script and can't expect manual actions
export DEBIAN_FRONTEND=noninteractive

# Update packages list
apt-get update

# Ugrade already installed packages
apt-get -y upgrade

# Update required packages
apt-get -y install --no-install-recommends \
    wget                                   \
    ca-certificates                        \
    xz-utils