#!/bin/bash
echo "=============================="
echo "Moving csye6225.service to /etc/systemd/system"
echo "=============================="
sudo mv /tmp/csye6225.service /etc/systemd/system/csye6225.service
echo "=============================="
echo "Enabling and starting csye6225.service"
echo "=============================="
sudo systemctl daemon-reload
sudo systemctl enable csye6225.service
