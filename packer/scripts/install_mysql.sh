#!/bin/bash
echo "=============================="
echo "Begin MySQL installation"
echo "=============================="
sudo dnf install mysql-server -y
sudo systemctl enable mysqld.service
sudo systemctl start mysqld.service
sudo systemctl status mysqld
echo "=============================="
echo "Completed MySQL installation"
echo "=============================="
