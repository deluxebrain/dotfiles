#!/bin/bash
# Setup SSH authorized keys and known hosts for passwordless access.
#
# Environment variables:
#   SSH_PUBLIC_KEY  - Public key to add to authorized_keys (required)
#   SSH_KNOWN_HOSTS - Space-separated hosts to add to known_hosts (default: "github.com")
set -eou pipefail

if [[ -z "${SSH_PUBLIC_KEY:-}" ]]; then
    echo "Error: SSH_PUBLIC_KEY environment variable is required" >&2
    exit 1
fi

SSH_HOSTS="${SSH_KNOWN_HOSTS:-github.com}"

echo "=== Setting up SSH ==="

mkdir -p ~/.ssh
chmod 700 ~/.ssh

echo "${SSH_PUBLIC_KEY}" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
echo "Added public key to authorized_keys"

for host in ${SSH_HOSTS}; do
    ssh-keyscan -H "${host}" >> ~/.ssh/known_hosts 2>/dev/null
    echo "Added ${host} to known_hosts"
done

echo "=== SSH setup complete ==="
