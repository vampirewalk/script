#!/bin/bash

clear

BASEDMGNAME="$(dirname "$0")/xcode_3.2.6_and_ios_sdk_4.3"
if [ $? -ne 0 ]; then
    echo "Error while looking up name of script's parent directory."
    exit 1
fi

DMGNAME="${BASEDMGNAME}.dmg"
SHADOWNAME="${BASEDMGNAME}.shadow"

if [ ! -f "${DMGNAME}" ]; then
    echo "Can not find ${DMGNAME} in current directory."
    exit 1
elif [ -f "${SHADOWNAME}" ]; then
    echo "Please remove conflicting shadow file: ${SHADOWNAME}"
    exit 1
fi

MOUNTPOINT="`mktemp -d -t xcodelion`"
if [ $? -ne 0 ]; then
    echo "Error while creating temporary directory."
    exit 1
fi

echo "Attaching disk image with a writable shadow..." && \
    hdiutil attach -mountpoint "${MOUNTPOINT}" -shadow "${SHADOWNAME}" "${DMGNAME}" && \
    echo "Patching installer package..." && \
    cat "${MOUNTPOINT}/Xcode and iOS SDK.mpkg/Contents/iPhoneSDKSL.dist" | sed "s/&amp;&amp; system.compareVersions(my.target.systemVersion.ProductVersion, '10.7') &lt; 0 //g" > "${MOUNTPOINT}/Xcode and iOS SDK.mpkg/Contents/iPhoneSDKSL.dist.new" && \
    mv "${MOUNTPOINT}/Xcode and iOS SDK.mpkg/Contents/iPhoneSDKSL.dist.new" "${MOUNTPOINT}/Xcode and iOS SDK.mpkg/Contents/iPhoneSDKSL.dist" && \
    echo "Opening Xcode installer..." && \
    open "${MOUNTPOINT}/Xcode and iOS SDK.mpkg" && \
    echo "Done. Please follow on-screen instructions to install Xcode and eject the" && \
    echo "disk image when you are done." && \
    echo "The temporary file ${SHADOWIMAGE} can be removed when the install process is completed and the" && \
    echo "disk image has been ejected."
