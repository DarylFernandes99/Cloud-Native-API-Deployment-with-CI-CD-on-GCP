#!/bin/bash
echo "=============================="
echo "Installing unzip package"
echo "=============================="
sudo yum install unzip -y
echo "=============================="
echo "Begin unzipping project file"
echo "=============================="
sudo mkdir -p /home/webapp-main/
sudo unzip /tmp/webapp-main.zip -d /home/webapp-main/
echo "=============================="
echo "Transfer ownership of application data to the new user"
echo "=============================="
sudo chown -R csye6225:csye6225 /home/webapp-main /tmp/csye6225.service
