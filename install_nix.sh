#!/usr/bin/bash

# Exit bash immediately if any command has a non-zero return code
set -o errexit

# Treat unset variables as an erorr
set -o nounset

# Do not mask errror in pipes
set -o pipefail

set -x

# Default nix version
readonly NIX_DEFAULT_VERSION=2.24.10
readonly NIX_INSTALLER_DEFAULT_DIRPATH="/tmp/nix-installer"

nix_download () {
    local -r nix_version=${1:-${NIX_DEFAULT_VERSION}}
    local -r nix_installer_dirpath=${2:-${NIX_INSTALLER_DEFAULT_DIRPATH}}

    local -r hw_architecture=$(uname --machine)
    local -r nix_release_url="https://nixos.org/releases/nix/nix-${nix_version}/nix-${nix_version}-${hw_architecture}-linux.tar.xz"
    wget ${nix_release_url} --directory-prefix="/tmp"

    local -r nix_release_filename="nix-${nix_version}-${hw_architecture}-linux.tar.xz"
    tar --extract --file="/tmp/${nix_release_filename}" --one-top-level=${nix_installer_dirpath} --strip-components=1
    rm /tmp/${nix_release_filename}
}

_nix_createBuilders () {
    addgroup --system -gid 30000 nixbld
    for i in $(seq 1 30); do
        useradd --system --groups nixbld nixbld$i
    done
}

_nix_loadInitialConfig() {

    mkdir --mode 0755 /etc/nix
    echo "experimental-features = nix-command flakes" > /etc/nix/nix.conf
}

nix_install () {
    _nix_createBuilders
    _nix_loadInitialConfig

    mkdir --mode 0755 /nix

    local -r nix_installer_dirpath=${2:-${NIX_INSTALLER_DEFAULT_DIRPATH}}
    USER=root ${nix_installer_dirpath}/install
    
    ln -s /nix/var/nix/profiles/default/etc/profile.d/nix.sh /etc/profile.d/
    /nix/var/nix/profiles/default/bin/nix-collect-garbage --delete-old
    /nix/var/nix/profiles/default/bin/nix-store --optimise
    /nix/var/nix/profiles/default/bin/nix-store --verify --check-contents
}

nix_download
nix_install
