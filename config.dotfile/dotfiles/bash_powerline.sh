if ! command -v powerline-daemon >/dev/null 2>&1; then
    true; return
fi

export POWERLINE_BASH_CONTINUATION=1
export POWERLINE_BASH_SELECT=1

# Ensure the powerline-daemon is started before starting powerline
powerline-daemon -q

# Start powerline

# Option 1) If installed through apt
# source "/usr/share/powerline/bindings/bash/powerline.sh"

# Option 2) If installed through pip into the active python
source "$(pip show powerline-status 2>/dev/null \
    | grep Location \
    | awk '{print $2}' \
    | echo "`cat -`/powerline/bindings/bash/powerline.sh")"
