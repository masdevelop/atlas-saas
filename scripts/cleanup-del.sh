#!/bin/bash
### When all else fails, cleanup and start up again. 
### Do this if there are drive conflicts in virtualbox
# Fetch all UUIDs from VBoxManage list hdds and unregister each one
VBoxManage list hdds | grep 'UUID:' | while read -r line; do
    # Extract UUID from the line
    uuid=$(echo $line | awk '{print $2}')
    
    # Output the UUID being unregistered
    echo "Unregistering HDD with UUID: $uuid"
    
    # Unregister the HDD
    VBoxManage closemedium disk "$uuid" --delete
done

rm -Rf ~/.config/VirtualBox/
rm -Rf ~/.terraform


