# Unalias anything brought in by plugins that causes an issue

# List alias conflicts
# see: https://github.com/ohmyzsh/ohmyzsh/issues/5115
# for help understanding this function:
# https://unix.stackexchange.com/questions/237080/what-does-the-do-in-commands
# https://scriptingosx.com/2019/11/associative-arrays-in-zsh/
function unalias.conflicts() {
  local alias value
  for alias value in ${(kv)aliases}; do
    if (( ${+commands[$alias]} )) && [[ "$value" != (|noglob |command |\\)${alias}* ]]; then
      echo "Conflict: alias $alias ('$value') <-> command $alias ('${commands[$alias]}')"
    fi
  done
}

# alias gm ('git merge') <-> command gm ('/opt/homebrew/bin/gm')
unalias gm
