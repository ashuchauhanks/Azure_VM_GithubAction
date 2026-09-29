#!/bin/bash
set -euo pipefail

echo "========================================"
echo " DevOps Tools Installation Started"
echo " $(date -Is)"
echo "========================================"

# ----------------------------------------
# Node.js + npm
# ----------------------------------------

if ! command -v node >/dev/null 2>&1; then

  curl -fsSL https://deb.nodesource.com/setup_22.x | bash -

  apt-get install -y nodejs

fi

# ----------------------------------------
# TFLint
# ----------------------------------------

if ! command -v tflint >/dev/null 2>&1; then

  TFLINT_VERSION="0.64.0"

  curl -fsSL \
    https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh \
    | bash -s -- -v "${TFLINT_VERSION}"

fi

# ----------------------------------------
# Checkov
# ----------------------------------------

if ! command -v checkov >/dev/null 2>&1; then

  python3 -m pip install --break-system-packages checkov

fi

# ----------------------------------------
# tfsec
# ----------------------------------------

if ! command -v tfsec >/dev/null 2>&1; then

  TFSEC_VERSION="1.28.14"

  curl -fsSL -o /tmp/tfsec.tar.gz \
    "https://github.com/aquasecurity/tfsec/releases/download/v${TFSEC_VERSION}/tfsec_${TFSEC_VERSION}_linux_amd64.tar.gz"

  tar -xzf /tmp/tfsec.tar.gz -C /usr/local/bin tfsec

  rm -f /tmp/tfsec.tar.gz

fi

# ----------------------------------------
# Infracost
# ----------------------------------------

if ! command -v infracost >/dev/null 2>&1; then

  curl -fsSL \
    https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh \
    | sh

fi

# ----------------------------------------
# Verification
# ----------------------------------------

echo ""
echo "========================================"
echo " DevOps Tools Installed"
echo "========================================"

node --version
npm --version
tflint --version
checkov --version
tfsec --version
infracost --version

echo ""
echo "========================================"
echo " DevOps Tools Installation Completed"
echo " $(date -Is)"
echo "========================================"