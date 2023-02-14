#!/bin/bash

# Install Samba
yum install samba -y

# Get user and directory information
read -p "Enter the username for the Samba share: " USERNAME
read -p "Enter the password for the Samba share: " PASSWORD
read -p "Enter the absolute path for the directory to be shared: " SHARE_DIRECTORY

# Create the user
useradd $USERNAME
echo $PASSWORD | passwd --stdin $USERNAME

smbpasswd -a $USERNAME <<< "$PASSWORD"$'\n'"$PASSWORD"

# Create the directory and set permissions
mkdir -p $SHARE_DIRECTORY
chown -R $USERNAME:$USERNAME $SHARE_DIRECTORY
chmod -R 700 $SHARE_DIRECTORY

# Configure Samba
echo "[$USERNAME]" >> /etc/samba/smb.conf
echo "path = $SHARE_DIRECTORY" >> /etc/samba/smb.conf
echo "valid users = $USERNAME" >> /etc/samba/smb.conf
echo "writable = yes" >> /etc/samba/smb.conf
echo "browsable = yes" >> /etc/samba/smb.conf
echo "guest ok = no" >> /etc/samba/smb.conf

# Restart Samba
systemctl restart smb

