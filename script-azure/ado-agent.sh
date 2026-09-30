#!/bin/bash
set -euo pipefail

ADO_ORG_URL="${ADO_ORG_URL:?ADO_ORG_URL is required}"
ADO_PAT="${ADO_PAT:?ADO_PAT is required}"
ADO_POOL="${ADO_POOL:-selfhost-aks}"
AGENT_NAME="${AGENT_NAME:-$(hostname)}"
AGENT_VERSION="${AGENT_VERSION:-5.279.0}"

AGENT_USER="azureuser"
AGENT_DIR="/home/${AGENT_USER}/myagent"

echo "========================================"
echo " Azure DevOps Agent Setup"
echo "========================================"

mkdir -p "${AGENT_DIR}"
chown -R "${AGENT_USER}:${AGENT_USER}" "${AGENT_DIR}"

cd "${AGENT_DIR}"

# ----------------------------------------
# Download & Extract Agent
# ----------------------------------------

if [ ! -f "${AGENT_DIR}/config.sh" ]; then

  echo "ADO Agent not installed. Installing..."

  AGENT_PACKAGE="vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz"

  curl -fL \
    -o "${AGENT_PACKAGE}" \
    "https://download.agent.dev.azure.com/agent/${AGENT_VERSION}/${AGENT_PACKAGE}"

  tar -xzf "${AGENT_PACKAGE}"

  rm -f "${AGENT_PACKAGE}"

  chown -R "${AGENT_USER}:${AGENT_USER}" "${AGENT_DIR}"

else

  echo "ADO Agent files already exist. Skipping download."

fi

# ----------------------------------------
# Configure Agent
# ----------------------------------------

if [ ! -f "${AGENT_DIR}/.agent" ]; then

  echo "ADO Agent not configured. Configuring..."

  sudo -u "${AGENT_USER}" bash -c "
    cd '${AGENT_DIR}'

    ./config.sh \
      --unattended \
      --url '${ADO_ORG_URL}' \
      --auth pat \
      --token '${ADO_PAT}' \
      --pool '${ADO_POOL}' \
      --agent '${AGENT_NAME}' \
      --replace \
      --acceptTeeEula
  "

else

  echo "ADO Agent already configured. Skipping configuration."

fi

# ----------------------------------------
# Agent Service
# ----------------------------------------

cd "${AGENT_DIR}"

if [ ! -f "${AGENT_DIR}/.service" ]; then

  echo "ADO Agent service not installed. Installing..."

  ./svc.sh install "${AGENT_USER}"

else

  echo "ADO Agent service already installed. Skipping service installation."

fi

# ----------------------------------------
# Enable & Start Service
# ----------------------------------------

SERVICE_NAME=$(systemctl list-unit-files --type=service \
  | awk '/^vsts\.agent\..*\.service/ {print $1; exit}')

if [ -z "${SERVICE_NAME}" ]; then
  echo "ERROR: Azure DevOps agent service not found."
  exit 1
fi

echo "Agent Service: ${SERVICE_NAME}"

systemctl enable "${SERVICE_NAME}"
systemctl start "${SERVICE_NAME}"

# ----------------------------------------
# Verify
# ----------------------------------------

if systemctl is-active --quiet "${SERVICE_NAME}"; then
  echo "Azure DevOps Agent service is running."
else
  echo "ERROR: Azure DevOps Agent service is not running."
  systemctl status "${SERVICE_NAME}" --no-pager || true
  exit 1
fi

echo ""
echo "========================================"
echo " Azure DevOps Agent Ready"
echo "========================================"

echo "Organization : ${ADO_ORG_URL}"
echo "Pool         : ${ADO_POOL}"
echo "Agent        : ${AGENT_NAME}"
echo "Directory    : ${AGENT_DIR}"
echo "Service      : ${SERVICE_NAME}"
echo "========================================"