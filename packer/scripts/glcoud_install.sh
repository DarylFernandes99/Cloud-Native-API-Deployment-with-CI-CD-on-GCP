#!/bin/bash
echo "=============================="
echo "Begin installation of gcloud CLI"
echo "=============================="
sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM
sudo dnf install google-cloud-cli
echo "=============================="
echo "Setup GOOOGLE_APPLICATION_CRDENTIALS environment variable"
echo "=============================="
export GOOGLE_CLOUD_CREDENTIALS="/home/webapp-main/gcloud_config.json"
echo $GOOGLE_CLOUD_CREDENTIALS
