#!/bin/zsh

# rectangle extensions

# syncs rectangle configuration with dotfiles
function rectangle.sync() {
    defaults export com.knollsoft.Rectangle \
        "$XDG_CONFIG_HOME/rectangle/com.knollsoft.Rectangle.plist"
}
