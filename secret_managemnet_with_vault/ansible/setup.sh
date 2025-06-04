#!/bin/bash

apt-get update
apt-get install -y openssh-server sudo python3

useradd -m ansible
echo "ansible:ansible" | chpasswd
mkdir -p /home/ansible/.ssh
chmod 700 /home/ansible/.ssh
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config
