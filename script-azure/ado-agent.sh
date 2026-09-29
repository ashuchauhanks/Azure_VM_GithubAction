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

apt-get update

apt-get install -y \
  curl \
  jq \
  unzip \
  tar \
  git

mkdir -p "${AGENT_DIR}"
chown -R "${AGENT_USER}:${AGENT_USER}" "${AGENT_DIR}"

cd "${AGENT_DIR}"

if [ ! -f "${AGENT_DIR}/config.sh" ]; then

  AGENT_PACKAGE="vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz"

  curl -fL \
    -o "${AGENT_PACKAGE}" \
    "https://download.agent.dev.azure.com/agent/${AGENT_VERSION}/${AGENT_PACKAGE}"

  tar -xzf "${AGENT_PACKAGE}"

  rm -f "${AGENT_PACKAGE}"

  chown -R "${AGENT_USER}:${AGENT_USER}" "${AGENT_DIR}"

fi

if [ -f "${AGENT_DIR}/.agent" ]; then
  echo "Agent already configured."
  exit 0
fi

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

cd "${AGENT_DIR}"

./svc.sh install "${AGENT_USER}"
./svc.sh start

echo ""
echo "========================================"
echo " Azure DevOps Agent Ready"
echo "========================================"

echo "Organization : ${ADO_ORG_URL}"
echo "Pool         : ${ADO_POOL}"
echo "Agent        : ${AGENT_NAME}"
echo "Directory    : ${AGENT_DIR}"