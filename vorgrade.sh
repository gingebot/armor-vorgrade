#! /bin/bash
set -e
 
VERSION="0.2"
NEW_SECFSD_REL=0
TMP_DIR=`mktemp -d -t ci-XXXXXXXXXX`
 
while getopts 'hv' OPTION; do
        case "$OPTION" in
        v)
                echo "vesion $VERSION"
                exit 0
                ;;
        h)
                printf "Usage: $(basename $0) \n check for a new release vormetric agent.\n\nOptions:\n\t-h help\n\t-v version\n" >&2
                exit 0
                ;;
        ?)
                printf "Usage: $(basename $0) \n check for a new release vormetric agent.\n\nOptions:\n\t-h help\n\t-v version\n" >&2
                exit 0
                ;;
        esac
done
shift "$(($OPTIND -1))"
 
Cleanup () {
 
        rm -rf "$TMP_DIR"
}
trap Cleanup EXIT
 
CheckPackages () {
if [[ ! -f `which secfsd` ]]
        then echo "secfsd not installed, exiting"
        exit 1
fi
 
if [[ ! -f `which wget` ]]
        then
        echo "wget not installed, exiting"
        exit 1
fi
 
}
 
IdentifyOsRelease () {
releaseinfo=`cat /etc/*release*`
if [[ ! -z `echo $releaseinfo | grep -i ubuntu` ]]
        then
        OS=ubuntu
        OS_VER=`lsb_release -sr`
        if [[ $OS_VER != "16.04" && $OS_VER != "18.04" ]]
                then
                echo "Detected Ubuntu OS release $OS_VER, not supported plesae contact support"
                exit 1
        fi
 
elif [[ ! -z `echo $releaseinfo | grep -i centos` ]]
        then
        OS=centos
        OS_VER=`rpm --eval %{centos_ver}`
        if [[ $OS_VER != "6" && $OS_VER != "7" ]]
                then
                echo "Detected Centos OS release $OS_VER, not supported plesae contact support"
                exit 1
        fi
else
        echo "OS unidentifiable, please contact support"
        exit 1
fi
}
 
GetHostname () {
        HOSTNAME=`hostname`
}
 
GetIps () {
        IPS=`hostname -I`
}
 
Downloader () {
        wget $1  -O $TMP_DIR/vee-fs-latest.bin &> /dev/null || { echo "Agent download failed, please confirm connectivity to http://a.svc.armor.com and then contact Armor support."; exit 1; }
        chmod +x $TMP_DIR/vee-fs-latest.bin
}
 
DownloadLatestAgent() {
        case $OS in
        ubuntu)
                case $OS_VER in
                        16.04)
                                Downloader http://a.svc.armor.com/downloads/Vormetric/FS/vee-fs-latest-ubuntu16-x86_64.bin
                                ;;
                        18.04)
                                Downloader http://a.svc.armor.com/downloads/Vormetric/FS/vee-fs-latest-ubuntu18-x86_64.bin
                                ;;
                esac
        ;;
        centos)
                case $OS_VER in
                        6)
                                Downloader http://a.svc.armor.com/downloads/Vormetric/FS/vee-fs-latest-rh6-x86_64.bin
                                ;;
                        7)
                                Downloader  http://a.svc.armor.com/downloads/Vormetric/FS/vee-fs-latest-rh7-x86_64.bin
                                ;;
                esac
        ;;
        esac
}
 
IdentifyCurrentVeeFsVersion () {
VEEFS_CURRENT_VERSION=`secfsd -version | egrep -o "([0-9]\.)+[0-9]+"`
}
 
IdentifyLatestVeeFsVersion() {
for i in `$TMP_DIR/vee-fs-latest.bin -m`; do declare $i;done
VEEFS_LATEST_VERSION="$VORMETRIC_VERSION.$VORMETRIC_BUILDID"
}
 
CompareSecFsVersions () {
if [ "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1" ]
        then
        NEW_SECFSD_REL=1
        else
        NEW_SECFSD_REL=0
fi
}
 
CurrentKernel () {
        CURRENT_KERNEL=`uname -r`
}
 
UbuntuNewKernelCheck () {
        NEW_KERNEL_PACKAGE=`apt upgrade --dry-run 2>/dev/null | grep -E "Inst linux-image-[0-9]+" | egrep -o "[0-9]+.+generic" || echo "N/A"`
        if [[ $NEW_KERNEL_PACKAGE != *generic* ]]
                then
                NEW_KERNEL_PACKAGE="N/A"
        fi
}
 
CentosNewKernelCheck () {
        NEW_KERNEL_PACKAGE=`yum check-update --disableexcludes=all | grep kernel | grep -oP "[0-9]+\.[0-9]+\.\S+" || echo N/A`
        if [[ $NEW_KERNEL_PACKAGE != *el* ]]
                then
                NEW_KERNEL_PACKAGE="N/A"
        fi
}
 
NewKernelCheck () {
case $OS in
        ubuntu)
                UbuntuNewKernelCheck
                ;;
        centos)
                CentosNewKernelCheck
                ;;
        esac
}
 
SupportedKernels () {
        cd $TMP_DIR
        $TMP_DIR/vee-fs-latest.bin -e > /dev/null
        SUPPORTED_KERNELS=`<$TMP_DIR/supported_kernel_list`
                }
 
 
CurrentKernelSupport () {
if [[ $SUPPORTED_KERNELS =~ $CURRENT_KERNEL ]]
        then
                CURRENT_KERNEL_SUPPORT="YES"
        else
                CURRENT_KERNEL_SUPPORT="NO"
fi
 
}
 
LatestKernelSupport () {
if [[ "$NEW_KERNEL_PACKAGE" == "N/A" ]]
        then
                LATEST_KERNEL_SUPPORT="N/A"
 
elif [[ $SUPPORTED_KERNELS =~ $NEW_KERNEL_PACKAGE ]]
        then
                LATEST_KERNEL_SUPPORT="YES"
        else
                LATEST_KERNEL_SUPPORT="NO"
fi
}
 
IdentifyOsRelease
DownloadLatestAgent
IdentifyCurrentVeeFsVersion
IdentifyLatestVeeFsVersion
CompareSecFsVersions $VEEFS_LATEST_VERSION $VEEFS_CURRENT_VERSION
 
if [ $NEW_SECFSD_REL == 1 ]
        then
                GetHostname
                GetIps
                CurrentKernel
                SupportedKernels
                NewKernelCheck
                CurrentKernelSupport
                LatestKernelSupport
 
 
                printf '\nNew Vormetric agent available\n\n'
 
                printf 'Hostname:\n%s\n\n' $HOSTNAME
                printf 'IP Address(es):\n%s\n\n' $IPS
                printf 'Operating system:\t%s %s\n' $OS $OS_VER
                printf 'Current kernel:\t\t%s\n' $CURRENT_KERNEL
                printf 'Latest kernel:\t\t%s\n\n' $NEW_KERNEL_PACKAGE
 
                printf 'Current agent version:\t%s\n' $VEEFS_CURRENT_VERSION
                printf 'New agent version:\t%s\n\n' $VEEFS_LATEST_VERSION
 
                printf 'Current kernel supported by latest agent:\t%s\n' $CURRENT_KERNEL_SUPPORT
                printf 'Latest kernel supported by latest agent :\t%s\n\n' $LATEST_KERNEL_SUPPORT
                printf 'Fully kernel compatibility list for latest agent:\n\n'
                printf "$SUPPORTED_KERNELS"
                printf "\n\nPlease contact Armor support by raising a support if you would like a vormetric agent/kernel upgrade.\nPlease include this output in the ticket to assist our engineers.\n\nKind regards,\n\nFriendly Armor Support Script.\n"
        else
                printf "\nVormetric agent upgrade check complete, no new agent available.\n\n"
 
                printf 'Hostname:\n%s\n\n' $HOSTNAME
                printf 'IP Address(es):\n%s\n\n' $IPS
fi
exit 0
