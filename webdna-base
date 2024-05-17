#!/bin/sh

# Defaults
SCRIPT_VERSION="${SCRIPT_VERSION:-v0.4.0-alpha}"
LOGIT_LOG="${LOGIT_LOG:-webdna_log.txt}"
WEBDNA_TYPE="${WEBDNA_TYPE:-FastCGI}"
WEBDNA_VERSION="${WEBDNA_VERSION:-8.6.5}"
INSTALL_DEPENDENCIES="${INSTALL_DEPENDENCIES:-Yes}"

## OS Vars
OS_DISTRIBUTION=""
OS_DISTRIBUTION_FAMILY=""
OS_VERSION=""
OS_VERSION_NAME=""
OS_PACKAGE_MGR=""
OS_PACKAGE_MGR_UPDATE_CMD=""
OS_PACKAGE_MGR_UPGRADE_CMD=""
OS_PACKAGE_MGR_INSTALL_CMD=""
OS_PACKAGE_MGR_REMOVE_CMD=""
OS_PACKAGE_MGR_CLEAN_CMD=""
OS_PACKAGE_MGR_CHECK=""

## Error Codes
ERR_INTERNAL=99
ERR_OS_NODETECT=100
ERR_OS_UNSUPPORTED=101
ERR_DEPENDENCY_INSTALL_FAILED=102

## Get Script Parameters
while [[ "$#" -gt 0 ]]
do
    case $1 in
        --type)
        ;;
        --version)
            echo "$SCRIPT_VERSION"
            exit 0
        ;;
    esac
    shift
done

## Predefined Values
export DEBIAN_FRONTEND=noninteractive

## 'Touch' Log File
touch "$LOGIT_LOG"

## Logging Function
log_it() {
    cur_date=$(date -u +"%Y-%m-%dT%H:%M:%S")
    echo "$cur_date	$0 $1" | tee -a "$LOGIT_LOG"
}

## Exit Script Function
graceful_exit(){
    # Should We Do Some Internal Error Checking Here?
    log_it "$2"
    exit "$1";
}

## Error Exit Function
err_exit(){
    graceful_exit "$1" "ERROR: $2 Exiting script."
}

## Internal Error Function
err_internal(){
    err_exit "$ERR_INTERNAL" "Internal Error."
}

# OS Init Functions
# These functions are used to set and detect a distribution automagically

## Check OS Distribution
check_os_distro(){
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_DISTRIBUTION=$ID
        OS_VERSION=$VERSION_ID
        OS_VERSION_NAME=$VERSION_CODENAME
    else
        err_exit "$ERR_OS_NODETECT" "Can't Determine OS Distribution."
    fi

    # Fedora detection needs to be tested!
    if [ "$OS_DISTRIBUTION" = "ol" ] ||
       [ "$OS_DISTRIBUTION" = "rocky" ] ||
       [ "$OS_DISTRIBUTION" = "almalinux" ] ||
       [ "$OS_DISTRIBUTION" = "rhel" ] ||
       [ "$OS_DISTRIBUTION" = "fedora" ] || 
       [ "$OS_DISTRIBUTION" = "centos" ]; then
        OS_DISTRIBUTION_FAMILY="fedora"
    elif [ "$OS_DISTRIBUTION" = "alpine" ]; then
        OS_DISTRIBUTION_FAMILY="alpine"
    elif [ "$OS_DISTRIBUTION" = "ubuntu" ] || 
         [ "$OS_DISTRIBUTION" = "debian" ]; then
        OS_DISTRIBUTION_FAMILY="debian"
    else
        err_exit $ERR_OS_UNSUPPORTED "OS Unsupported. OS Information: $OS_DISTRIBUTION $OS_VERSION $OS_VERSION_NAME"
    fi

    log_it "OS Detected: $OS_DISTRIBUTION $OS_VERSION $OS_VERSION_NAME"
    
}

## Sets the appropriate package manager for the distro
set_package_manager(){

    if [ "$OS_DISTRIBUTION_FAMILY" = "fedora" ]; then
        ASSUMEYES=${ASSUMEYES:--y}
        OS_PACKAGE_MGR="yum"
        OS_PACKAGE_MGR_UPDATE_CMD="update"
        OS_PACKAGE_MGR_UPGRADE_CMD="upgrade"
        OS_PACKAGE_MGR_INSTALL_CMD="install"
        OS_PACKAGE_MGR_REMOVE_CMD="remove"
        OS_PACKAGE_MGR_CLEAN_CMD="clean all"
        OS_PACKAGE_MGR_CHECK="rpm -q"
    elif [ "$OS_DISTRIBUTION_FAMILY" = "debian" ]; then
        ASSUMEYES=${ASSUMEYES:--y}
        OS_PACKAGE_MGR="apt-get"
        OS_PACKAGE_MGR_UPDATE_CMD="update"
        OS_PACKAGE_MGR_UPGRADE_CMD="upgrade"
        OS_PACKAGE_MGR_INSTALL_CMD="install"
        OS_PACKAGE_MGR_REMOVE_CMD="remove"
        OS_PACKAGE_MGR_CLEAN_CMD="clean all"
        OS_PACKAGE_MGR_CHECK="dpkg -l"
    elif [ "$OS_DISTRIBUTION_FAMILY" = "alpine" ]; then
        ASSUMEYES=${ASSUMEYES}
        OS_PACKAGE_MGR="apk"
        OS_PACKAGE_MGR_UPDATE_CMD="upgrade"
        #OS_PACKAGE_MGR_UPGRADE_CMD="upgrade"
        OS_PACKAGE_MGR_INSTALL_CMD="add"
        OS_PACKAGE_MGR_REMOVE_CMD="del"
        OS_PACKAGE_MGR_CLEAN_CMD="cache clean"
        OS_PACKAGE_MGR_CHECK="$OS_PACKAGE_MGR -e info"
    else
        err_exit $ERR_OS_UNSUPPORTED "OS Unsupported. OS Information: $OS_DISTRIBUTION $OS_VERSION $OS_VERSION_NAME"
    fi

    log_it "OS Package Manager Detected Via Distro Family: $OS_DISTRIBUTION_FAMILY"

}

## Init the script
init_script(){

    ## Check the distribution
    check_os_distro

    ## Set The Package Manager
    set_package_manager

}

# Checks current system for installed package
check_for_package() {
    if eval "$OS_PACKAGE_MGR_CHECK $1"; then
        log_it "Required package '$1' already installed."
    else
        log_it "Required package '$1' not found."
        if [ "Yes" = "$INSTALL_DEPENDENCIES" ]; then
            log_it "Installing package '$1'"
            eval "$OS_PACKAGE_MGR $ASSUMEYES $OS_PACKAGE_MGR_INSTALL_CMD $1"
            if eval "$OS_PACKAGE_MGR_CHECK $1"; then
                log_it "Required package '$1' installed."
            else
                log_it "Installing Package '$1' Failed."
            fi
        fi
    fi
}



