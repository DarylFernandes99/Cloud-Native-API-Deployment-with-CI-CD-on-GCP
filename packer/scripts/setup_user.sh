#!/bin/bash
echo "=============================="
echo "Create a user with nologin"
echo "=============================="
sudo groupadd csye6225
sudo useradd -m -s /usr/sbin/nologin -g csye6225 csye6225
echo "=============================="
echo "Disable SELinux"
echo "=============================="
sudo sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sudo sed -i 's/^SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
sudo setenforce 0
