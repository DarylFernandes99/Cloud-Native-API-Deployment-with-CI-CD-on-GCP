#!/bin/bash
echo "=============================="
echo "Begin Python3.8 installation"
echo "=============================="
sudo dnf install python38 -y
sudo dnf install openssl-devel bzip2-devel libffi-devel -y
sudo yum install mariadb-devel gcc python38-devel -y
echo "=============================="
echo "Completed Python3.8 installation"
echo "=============================="
