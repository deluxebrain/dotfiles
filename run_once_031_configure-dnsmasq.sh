#!/bin/bash

set -euo pipefail

# Path to the main dnsmasq configuration file
DNSMASQ_CONF="$(brew --prefix)/etc/dnsmasq.conf"

# Path to the dnsmasq.d directory
DNSMASQ_D_DIR="$(brew --prefix)/etc/dnsmasq.d"

# Function to ensure dnsmasq.d directory exists and is configured
configure_dnsmasq() {
    echo "[Configuration] Configuring dnsmasq to use $DNSMASQ_D_DIR for additional configuration files..."

    # Create the dnsmasq.d directory if it doesn't exist
    if [[ ! -d "$DNSMASQ_D_DIR" ]]; then
        echo "Creating directory: $DNSMASQ_D_DIR"
        mkdir -p "$DNSMASQ_D_DIR"
    else
        echo "✔ Directory already exists: $DNSMASQ_D_DIR"
    fi

    # Ensure conf-dir is uncommented and correctly configured
    if grep -q "#conf-dir=$DNSMASQ_D_DIR/,*.conf" "$DNSMASQ_CONF"; then
        echo "Uncommenting and configuring conf-dir=$DNSMASQ_D_DIR"
        sed -i '' "s|#conf-dir=.*|conf-dir=$DNSMASQ_D_DIR|" "$DNSMASQ_CONF"
    elif ! grep -q "conf-dir=$DNSMASQ_D_DIR" "$DNSMASQ_CONF"; then
        echo "Adding conf-dir=$DNSMASQ_D_DIR to $DNSMASQ_CONF"
        echo "conf-dir=$DNSMASQ_D_DIR" >> "$DNSMASQ_CONF"
    else
        echo "✔ dnsmasq.conf already configured to include $DNSMASQ_D_DIR"
    fi
}

# Function to check if dnsmasq is registered as a system-level service
check_registered() {
    sudo brew services list | grep dnsmasq | grep -q "root"
    if [[ $? -eq 0 ]]; then
        echo "✔ dnsmasq is registered as a system-level service (root)."
        return 0
    else
        echo "✘ dnsmasq is NOT registered as a system-level service."
        return 1
    fi
}

# Function to restart dnsmasq as a system-level service
restart_dnsmasq() {
    echo "Restarting dnsmasq as a system-level service..."
    brew services stop dnsmasq &>/dev/null
    sudo brew services start dnsmasq
    if [[ $? -eq 0 ]]; then
        echo "✔ dnsmasq has been successfully registered and started as a system-level service."
    else
        echo "✘ Failed to start dnsmasq as a system-level service. Check for errors."
        exit 1
    fi
}

echo "[Configuration] Checking dnsmasq registration and configuration..."

# Step 1: Check registration
check_registered
if [[ $? -ne 0 ]]; then
    echo "Attempting to fix dnsmasq registration..."
    restart_dnsmasq
fi

# Step 2: Configure dnsmasq
configure_dnsmasq

# Step 3: Restart dnsmasq to apply new configuration
echo "Restarting dnsmasq to apply configuration..."
restart_dnsmasq

echo "✔ dnsmasq is properly configured and running with $DNSMASQ_D_DIR included."
