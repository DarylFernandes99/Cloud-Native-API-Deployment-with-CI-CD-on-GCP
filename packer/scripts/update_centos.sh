#!/bin/bash
echo "=============================="
echo "Begin updating CentOS 8"
echo "=============================="
sudo yum update -y
sudo yum upgrade -y
sudo dnf update -y
echo "=============================="
echo "Completed updating CentOS 8"
echo "=============================="
