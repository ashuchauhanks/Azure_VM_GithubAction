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

# ----------------------------------------
# Required Commands Check
# ----------------------------------------

for cmd in curl unzip python3; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "ERROR: Required command not found: $cmd"
        echo "These should already be installed by bootstrap.sh"
        exit 1
    fi
done

# ----------------------------------------
# TFLint
# ----------------------------------------

echo ""
echo "========================================"
echo " TFLint"
echo "========================================"

if [ -x /usr/local/bin/tflint ]; then

    echo "TFLint already installed:"
    /usr/local/bin/tflint --version

else

    echo "Installing TFLint..."

    TMP_DIR=$(mktemp -d)

    curl -fL \
        https://github.com/terraform-linters/tflint/releases/latest/download/tflint_linux_amd64.zip \
        -o "${TMP_DIR}/tflint.zip"

    unzip -o \
        "${TMP_DIR}/tflint.zip" \
        -d "${TMP_DIR}"

    install -m 0755 \
        "${TMP_DIR}/tflint" \
        /usr/local/bin/tflint

    rm -rf "${TMP_DIR}"

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

/usr/local/bin/checkov --version

# ----------------------------------------
# tfsec
# ----------------------------------------

echo ""
echo "========================================"
echo " tfsec"
echo "========================================"

if [ -x /usr/local/bin/tfsec ]; then

    echo "tfsec already installed:"
    /usr/local/bin/tfsec --version

else

    echo "Installing tfsec..."

    TMP_DIR=$(mktemp -d)

    curl -fL \
        https://github.com/aquasecurity/tfsec/releases/latest/download/tfsec-linux-amd64 \
        -o "${TMP_DIR}/tfsec"

    install -m 0755 \
        "${TMP_DIR}/tfsec" \
        /usr/local/bin/tfsec

    rm -rf "${TMP_DIR}"

    /usr/local/bin/tfsec --version

fi

# ----------------------------------------
# Infracost
# ----------------------------------------

echo ""
echo "========================================"
echo " Infracost"
echo "========================================"

if [ -x /usr/local/bin/infracost ]; then

    echo "Infracost already installed:"
    /usr/local/bin/infracost --version

else

    echo "Installing Infracost..."

    TMP_DIR=$(mktemp -d)

    curl -fL \
        https://github.com/infracost/infracost/releases/latest/download/infracost-linux-amd64.tar.gz \
        -o "${TMP_DIR}/infracost.tar.gz"

    tar -xzf \
        "${TMP_DIR}/infracost.tar.gz" \
        -C "${TMP_DIR}"

    install -m 0755 \
        "${TMP_DIR}/infracost-linux-amd64/infracost" \
        /usr/local/bin/infracost

    rm -rf "${TMP_DIR}"

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
echo " $(date -Is)"
echo "========================================"


sudo az aks install-cli

kubectl version --client
which kubectl