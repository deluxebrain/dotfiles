#!/bin/bash

# This script is run after changes to .zprofile are applied.
# It is used to reload the Zsh shell to apply the changes.

set -eu

# Reload Zsh shell
echo "[Notice] Reloading Zsh session..."
exec zsh
