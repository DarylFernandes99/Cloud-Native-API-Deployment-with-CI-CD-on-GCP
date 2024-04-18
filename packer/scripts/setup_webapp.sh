#!/bin/bash
echo "=============================="
echo "Setup environment and install requirements"
echo "=============================="
cd /home/webapp-main || exit
ls -al
# sudo chmod 755 ./run_setup.sh
# source ./run_setup.sh
sudo chmod 755 ./install_requirements.sh
source ./install_requirements.sh
sudo mkdir -p /home/webapp-main/logs
sudo touch /home/webapp-main/logs/logfile.log
sudo chown -R csye6225:csye6225 /home/webapp-main
ls -al
cd - || exit
