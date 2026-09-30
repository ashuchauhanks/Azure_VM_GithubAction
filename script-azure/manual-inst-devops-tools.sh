#!/bin/bash
set -euo pipefail

echo "========================================"
echo " DevOps Tools Installation"
echo " $(date -Is)"
echo "========================================"

# ----------------------------------------
# Root Check
# ----------------------------------------

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run with sudo"
    echo "Usage: sudo bash ~/manual-inst-devops-tools.sh"
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

# ----------------------------------------
# Base Packages
# ----------------------------------------

echo ""
echo "Installing required packages..."

apt-get update

apt-get install -y \
    curl \
    unzip \
    jq \
    python3 \
    python3-venv \
    ca-certificates

# ----------------------------------------
# TFLint
# ----------------------------------------

echo ""
echo "========================================"
echo " TFLint"
echo "========================================"

if command -v tflint >/dev/null 2>&1; then
    echo "TFLint already installed:"
    tflint --version
else
    echo "Installing TFLint..."

    TMP_DIR=$(mktemp -d)

    curl -fL \
        https://github.com/terraform-linters/tflint/releases/latest/download/tflint_linux_amd64.zip \
        -o "${TMP_DIR}/tflint.zip"

    unzip -o "${TMP_DIR}/tflint.zip" -d "${TMP_DIR}"

    install -m 0755 \
        "${TMP_DIR}/tflint" \
        /usr/local/bin/tflint

    rm -rf "${TMP_DIR}"

    echo "TFLint installed:"
    /usr/local/bin/tflint --version
fi

# ----------------------------------------
# Checkov
# ----------------------------------------

echo ""
echo "========================================"
echo " Checkov"
echo "========================================"

CHECKOV_VENV="/opt/checkov"

if [ -x "${CHECKOV_VENV}/bin/checkov" ]; then
    echo "Checkov already installed."
else
    echo "Installing Checkov..."

    python3 -m venv "${CHECKOV_VENV}"

    "${CHECKOV_VENV}/bin/pip" install --upgrade pip
    "${CHECKOV_VENV}/bin/pip" install --upgrade checkov
fi

ln -sf \
    "${CHECKOV_VENV}/bin/checkov" \
    /usr/local/bin/checkov

echo "Checkov:"
/usr/local/bin/checkov --version

# ----------------------------------------
# tfsec
# ----------------------------------------

echo ""
echo "========================================"
echo " tfsec"
echo "========================================"

if command -v tfsec >/dev/null 2>&1; then
    echo "tfsec already installed:"
    tfsec --version
else
    echo "Installing tfsec..."

    curl -s \
        https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh \
        | bash

    chmod +x /usr/local/bin/tfsec

    echo "tfsec installed:"
    /usr/local/bin/tfsec --version
fi

# ----------------------------------------
# Infracost
# ----------------------------------------

echo ""
echo "========================================"
echo " Infracost"
echo "========================================"

if command -v infracost >/dev/null 2>&1; then
    echo "Infracost already installed:"
    infracost --version
else
    echo "Installing Infracost..."

    curl -fsSL \
        https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh \
        | sh

    chmod +x /usr/local/bin/infracost

    echo "Infracost installed:"
    /usr/local/bin/infracost --version
fi

# ----------------------------------------
# Final Verification
# ----------------------------------------

echo ""
echo "========================================"
echo " FINAL TOOL CHECK"
echo "========================================"

echo ""
echo "TFLint:"
command -v tflint
tflint --version

echo ""
echo "Checkov:"
command -v checkov
checkov --version

echo ""
echo "tfsec:"
command -v tfsec
tfsec --version

echo ""
echo "Infracost:"
command -v infracost
infracost --version

echo ""
echo "========================================"
echo " Installation Completed Successfully"
echo "========================================"