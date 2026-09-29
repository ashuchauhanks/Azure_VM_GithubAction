#!/bin/bash
set -euo pipefail

LOG_FILE="/var/log/azure-vm-bootstrap.log"

exec > >(tee -a "$LOG_FILE" | logger -t azure-vm-bootstrap -s 2>/dev/console) 2>&1

echo "========================================"
echo " Azure VM Bootstrap Started"
echo " $(date -Is)"
echo "========================================"

export DEBIAN_FRONTEND=noninteractive

# ----------------------------------------
# Base packages
# ----------------------------------------

apt-get update

apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  unzip \
  zip \
  p7zip-full \
  openssh-client \
  jq \
  git \
  python3 \
  python3-pip \
  python3-venv \
  build-essential \
  apt-transport-https

# ----------------------------------------
# Docker
# ----------------------------------------

if ! command -v docker >/dev/null 2>&1; then

  install -m 0755 -d /etc/apt/keyrings

  curl -fsSL \
    https://download.docker.com/linux/ubuntu/gpg \
    | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  chmod a+r /etc/apt/keyrings/docker.gpg

  . /etc/os-release

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${VERSION_CODENAME} stable" \
    > /etc/apt/sources.list.d/docker.list

  apt-get update

  apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin
fi

systemctl enable --now docker

usermod -aG docker azureuser || true

# newgrp docker

# ----------------------------------------
# Azure CLI
# ----------------------------------------

if ! command -v az >/dev/null 2>&1; then
  curl -sL https://aka.ms/InstallAzureCLIDeb | bash
fi

# ----------------------------------------
# Terraform
# ----------------------------------------

if ! command -v terraform >/dev/null 2>&1; then

  TERRAFORM_VERSION="1.16.4"

  curl -fsSLo /tmp/terraform.zip \
    "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

  unzip -o /tmp/terraform.zip -d /usr/local/bin

  rm -f /tmp/terraform.zip
fi

# ----------------------------------------
# Verification
# ----------------------------------------

echo ""
echo "========================================"
echo " Base Tools Installed"
echo "========================================"

git --version
az version --query '"azure-cli"' -o tsv
terraform version
docker --version
python3 --version
pip3 --version
curl --version | head -1
unzip -v | head -1
zip -v | head -1
7z | head -2
ssh -V

echo ""
echo "========================================"
echo " Bootstrap Completed"
echo " $(date -Is)"
echo "========================================"