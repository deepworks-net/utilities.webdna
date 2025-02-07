#!/bin/sh

## Load Shared header
. webdna-base.sh

OS_INSTALL_LIST=



#   eval "$OS_PACKAGE_MGR_INSTALL $1"
#        if eval "$OS_PACKAGE_MGR_CHECK $1"; then
#            log_it "Required package '$1' installed."
#        else
#            err_exit $ERR_DEPENDENCY_INSTALL_FAILED "Failed to install package '$1'"
#        fi

# Checks current system for information to determine if it is configured properly to handle WebDNA


# Checks WebDNA Install Health



## Init The Script
init_script

## Script Defaults
SCRIPT_VERSION="v0.1.0-alpha"

## Get Script Parameters

# Build Install List
#OS_INSTALL_LIST="httpd"
#check_for_package "wget"