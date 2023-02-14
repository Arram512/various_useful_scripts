#!/bin/bash

# Install Samba
apt-get update
apt-get install samba -y

# Get user and directory information
read -p "Enter the username for the Samba share: " USERNAME
read -p "Enter the password for the Samba share: " PASSWORD
read -p "Enter the absolute path for the directory to be shared: " SHARE_DIRECTORY

# Create the user and set the Samba password
useradd $USERNAME
echo -e "$PASSWORD\n$PASSWORD" | smbpasswd -a $USERNAME

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
systemctl restart smbd

