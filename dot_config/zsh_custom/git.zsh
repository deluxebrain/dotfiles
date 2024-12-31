# Git Aliases for Rollback and Checkpoints
# This file defines aliases to help create, rollback, and manage Git lightweight tags for future rollback.

# --- Usage Overview ---
# 1. Create a checkpoint (lightweight tag):
#    gcheckpoint <tag-name>
#    Example: gcheckpoint version-1.0

# 2. Rollback to a checkpoint (reset to a tag):
#    grollback <tag-name>
#    Example: grollback version-1.0

# 3. Delete a checkpoint (remove a tag):
#    gdelcheckpoint <tag-name>
#    Example: gdelcheckpoint version-1.0

# 4. List all checkpoints (list tags):
#    gcheckpoints

# --- Aliases ---
# Create a lightweight tag (checkpoint) at the current commit
# Usage: gcheckpoint <tag-name>
# Example: gcheckpoint my-checkpoint
alias gcheckpoint="git tag"

# Reset the current branch to a given checkpoint (rollback) and clean untracked files
# This will revert the working directory to the state at the given tag and remove untracked files
# Usage: grollback <tag-name>
# Example: grollback my-checkpoint
alias grollback="git reset --hard && git clean -fd"

# Delete a lightweight tag (checkpoint) when it's no longer needed
# Usage: gdelcheckpoint <tag-name>
# Example: gdelcheckpoint my-checkpoint
alias gdelcheckpoint="git tag -d"

# List all existing checkpoints (tags)
# Usage: gcheckpoints
alias gcheckpoints="git tag"
