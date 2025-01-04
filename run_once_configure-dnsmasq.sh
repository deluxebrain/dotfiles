#!/bin/bash

set -euo pipefail

echo "[Configuration] Checking dnsmasq registration and configuration..."

# Load Homebrew environment variables only if not already loaded
if ! command -v brew &>/dev/null; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Path to the main dnsmasq configuration file
DNSMASQ_CONF="$HOMEBREW_PREFIX/etc/dnsmasq.conf"

# Path to the dnsmasq.d directory
DNSMASQ_D_DIR="$HOMEBREW_PREFIX/etc/dnsmasq.d"

# Pattern in dnsmasq config file to enable custom config directory
PATTERN_CONF_DIR="conf-dir=$HOMEBREW_PREFIX/etc/dnsmasq.d/,\*.conf"

# Function to check if dnsmasq is registered as a system-level service
check_registered() {
    if sudo brew services list | grep -q dnsmasq; then
        echo "dnsmasq is registered as a system-level service (root)."
        return 0
    else
        echo "dnsmasq is NOT registered as a system-level service."
        return 1
    fi
}

# Function to ensure dnsmasq.d directory exists and is configured
configure_dnsmasq() {
    echo "Configuring dnsmasq to use $DNSMASQ_D_DIR for additional configuration files..."

    # Verify the dnsmasq config file is as expected
    if ! grep "$PATTERN_CONF_DIR" "$DNSMASQ_CONF" &>/dev/null; then
        echo "Unexpected dnsmasq configuration file contents"
        exit 1
    fi

    # Ensure conf-dir is uncommented and correctly configured
    gsed -i.bak "\:${PATTERN_CONF_DIR}:s:^#\s*::g" "$DNSMASQ_CONF"
}

# Function to start dnsmasq as a system-level service
start_dnsmasq_as_sudo() {
    echo "Restarting dnsmasq as a system-level service..."
    brew services stop dnsmasq &>/dev/null
    sudo brew services start dnsmasq
}

# Step 1: Check registration
if ! check_registered; then
    echo "Attempting to fix dnsmasq registration..."
    start_dnsmasq_as_sudo
fi

# Step 2: Configure dnsmasq
configure_dnsmasq

# Step 3: Restart dnsmasq to apply new configuration
echo "Restarting dnsmasq to apply configuration..."
sudo brew services restart dnsmasq
