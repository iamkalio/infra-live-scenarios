#!/bin/bash

set -e
# Ensure SSH runtime dir exists
mkdir -p /run/sshd

# Install OpenSSH server and required packages
apt-get update
apt-get install -y openssh-server sudo python3

# Create ansible user
useradd -m ansible
echo "ansible:ansible" | chpasswd
mkdir -p /home/ansible/.ssh
chmod 700 /home/ansible/.ssh

# Configure SSH
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config
