#!/bin/bash

## Defaults
SCRIPT_VERSION="v0.3.0-alpha"

## Load Shared header
. webdna-base.sh

## Script Defaults
WEBDNA_URL="${WEBDNA_URL:-https://webdna.us/download}"
DEPENDENCIES="wget unzip"

## Error Codes
ERR_FILE_VERIFY_FAILED=201

WEBDNA_TYPE="${WEBDNA_TYPE:-FastCGI}"
WEBDNA_VERSION="${WEBDNA_VERSION:-8.6.5}"
WEBDNA_FOLDER="${WEBDNA_FOLDER:-WebDNA-folder-8.6}"
WEBDNA_OS_FLAVOR="${WEBDNA_OS_FLAVOR:-Linux}"
if [ "alpine" = "$OS_DISTRIBUTION" ]; then WEBDNA_OS_FLAVOR="Alpine"; fi
WEBDNA="${LINUX_WEBDNA:-WebDNA-$WEBDNA_OS_FLAVOR-$WEBDNA_TYPE-$WEBDNA_VERSION}.zip"

#
# Functions
#

## Download a file from WebDNA
download_file() {
    log_it "Downloading $1 from $WEBDNA_URL"
    # (Will This Work Cross Platform?)
    wget "$WEBDNA_URL/$1"
}

## Verify a file from WebDNA (No Tamperin!)
verify_file() {
    log_it "Verifying $1"
    # Is this always installed?
    sha256sum "$1"
    if ! sha256sum -c "hashes/${1}.sha256"; then 
        log_it "sha256 Checksum failed for $1"; 
        err_exit $ERR_FILE_VERIFY_FAILED "Could Not Verify File $1"; 
    fi
    log_it "Verified $1"
}

## Extract Files
extract_files() {
    log_it "Extracting $1"
    unzip -d . "$1"
    log_it "Clean Up $1"
    rm -f "$1"
}

## Download Packages and 'Install' Them

## Check dependencies
check_dependencies() {
    check_for_package "wget"
    check_for_package "unzip"
}

## Download,Verify,Extract
dve() {
    download_file "$1"
    verify_file "$1"
    extract_files "$1"
    log_it "Downloaded, verified, and extracted $1"
}

check_dependencies

dve "$WEBDNA"
dve "$WEBDNA_FOLDER"
