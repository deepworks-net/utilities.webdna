#!/bin/sh

# Check For Required Packages
# Check For Minimum Version Numbers
# Check For Extra Mod Minimum Versions
# Once required packages are installed at a minimum version number-
    # Check httpd configuration health
    # Check for selinux (centos types)
    # Check for ODBC Drivers
    # Check for Java/Active X? (Check With Stuart)
    
## Load Shared header
. webdna-base.sh

## Script Defaults
SCRIPT_VERSION="v0.1.0-alpha"

## Init The Script
init_script

## Get Script Parameters

