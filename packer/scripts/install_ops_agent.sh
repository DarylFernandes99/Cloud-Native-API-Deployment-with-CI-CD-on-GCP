#!/bin/bash
echo "=============================="
echo "Begin Google Cloud Ops Agent installation"
echo "=============================="
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install
