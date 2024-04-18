#!/bin/bash
echo "=============================="
echo "Moving OPs agent configuration file"
echo "=============================="
sudo mv /etc/google-cloud-ops-agent/config.yaml /etc/google-cloud-ops-agent/config.yaml.bak
sudo mv /tmp/cloud_ops_agent_config.yaml /etc/google-cloud-ops-agent/config.yaml
sudo mkdir -p /var/log/webapp-main
sudo systemctl restart google-cloud-ops-agent
echo "=============================="
echo "Creating soft link of application logs file"
echo "=============================="
sudo ln -s /home/webapp-main/logs/logfile.log /var/log/webapp-main/logfile.log
