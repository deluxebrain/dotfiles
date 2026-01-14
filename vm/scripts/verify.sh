#!/bin/bash
# Verify that required tools are installed correctly.
#
# Environment variables:
#   VERIFY_HOMEBREW  - Check Homebrew installation (default: "true")
#   VERIFY_XCODE_CLT - Check Xcode CLT installation (default: "true")
#   VERIFY_GIT       - Check git availability (default: "true")
set -euo pipefail

VERIFY_HOMEBREW="${VERIFY_HOMEBREW:-true}"
VERIFY_XCODE_CLT="${VERIFY_XCODE_CLT:-true}"
VERIFY_GIT="${VERIFY_GIT:-true}"

errors=0

echo "=== Verifying installations ==="

if [[ "${VERIFY_HOMEBREW}" == "true" ]]; then
    echo -n "Homebrew: "
    if [[ -x "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        brew --version | head -n 1
    else
        echo "NOT INSTALLED"
        ((errors++))
    fi
fi

if [[ "${VERIFY_XCODE_CLT}" == "true" ]]; then
    echo -n "Xcode CLT: "
    if xcode-select -p &>/dev/null; then
        xcode-select -p
    else
        echo "NOT INSTALLED"
        ((errors++))
    fi
fi

if [[ "${VERIFY_GIT}" == "true" ]]; then
    echo -n "Git: "
    if command -v git &>/dev/null; then
        git --version
    else
        echo "NOT INSTALLED"
        ((errors++))
    fi
fi

if [[ "${errors}" -gt 0 ]]; then
    echo "=== VERIFICATION FAILED: ${errors} error(s) ==="
    exit 1
fi

echo "=== All verifications passed ==="
