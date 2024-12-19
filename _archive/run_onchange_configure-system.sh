#!/bin/bash

set -eu

echo "[Configuration] Configuring macOS system settings..."

#
# Text Editing and Input Behavior
#

# Disable automatic text modifications
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Keyboard behavior
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

#
# File Management and Storage
#

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

#
# Finder Configuration
#

# Show file details
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# File management behavior
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

#
# Dock Configuration
#

# Visual settings
defaults write com.apple.dock mouse-over-hilite-stack -bool true
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock mineffect -string "scale"

# Behavior settings
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock autohide -bool false
defaults write com.apple.dock show-recents -bool false

#
# Apply Changes
#

# Restart affected applications to ensure all settings take effect
# Note: This will briefly interrupt Finder and Dock
for app in "Activity Monitor" \
	"Dock" \
	"Finder" ; do
	killall "${app}" >/dev/null 2>&1 || true
done
