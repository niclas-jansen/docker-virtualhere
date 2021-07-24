#!/bin/sh -e
#
# Script used to setup and run virtualhere
if ! [ -x "$(command -v zerotier-cli)" ]; then
    curl -s https://install.zerotier.com | sudo bash
    sudo zerotier-cli join $NETWORK_ID
    sudo zerotier-cli listnetworks
else
    service zerotier-one start
    sudo zerotier-cli status
fi


ARCH=`uname -m`
if [ "$ARCH" = "x86_64" ]
then
    echo "Your system architecture was identified as $ARCH. The x86_64 version of the virtualhere-client will be used."
    ARCH_VR=vhusbdx86_64
else 
    echo "Your system architecture was identified as $ARCH. The ARM version of the virtualhere-client will be used."
    ARCH_VR=vhusbdarm 
fi

echo '*** Listing all usb-devices. Use this list to adjust AllowedDevices in config.ini ...'
lsusb || echo 'Execution of command lsusb failed. Make sure you have access to USB-Devices on the host.'

cd data

echo '*** Deleting previous bus_usb_*-files from data directory ...'
find . -name '*bus_usb_*' -delete
echo '*** Checking for new version of VirtualHere ...'
wget -N https://www.virtualhere.com/sites/default/files/usbserver/$ARCH_VR || echo 'Checking for remote copy of VirtualHere failed'

chmod +x ./$ARCH_VR
if [[ $SERVER_NAME != '' ]]
then 
    echo "ServerName=$SERVER_NAME" >> config.ini
fi
./$ARCH_VR

exit 0
