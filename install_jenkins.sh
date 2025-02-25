#!/bin/bash
sudo apt-get update -y
sudo apt-get install openjdk-17-jre-headless -y
sudo apt-get install -y ca-certificates curl gnupg
sudo apt-get update -y
sudo apt-get install maven -y
sudo apt-get update -y
sudo mkdir -p /usr/share/keyrings
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | \
  sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y jenkins
sudo systemctl daemon-reload
sudo systemctl enable Jenkins
sudo systemctl start Jenkins
sudo systemctl status Jenkins
sudo apt-get update -y
sudo apt-get install -y wget unzip
wget https://releases.hashicorp.com/terraform/1.10.5/terraform_1.10.5_linux_amd64.zip
unzip terraform_1.10.5_linux_amd64.zip
sudo mv terraform /usr/local/bin/
echo 'clearing screen...' && sleep 5
clear
echo 'jenkins is installed'
echo 'this is the default password :' $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
