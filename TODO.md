# TODO

## BUGS

- [] Sudo keep-alive is not working

## NEXT

- [] Document minimal vs full install type
- [] Migration guide ( for users with some existing dotfiles )
- [] Document how to pin packages ( limit to homebrew for now )
- [] Change how empty files are created ( e.g. ~/.ssh/config ). See chezmoi user
  guide: manage different types of file
- [] ~/.config/direnv/direnv.toml needs to be per user

## BACKLOG

- [] Secrets integration e.g. for ssh management ( see twpayne dotfiles:
  private_dot_ssh )
- [] Verify if gitUserName needs default "". Without it is value "" or null?
- [] Verify what happens when running chezmoi init --prompt wrt existing
  configuration when not answering any question
- [] Document tmux usage
- [] Chezmoi autocommit?
- [] Override vim to chezmoi edit managed files
- [] Rectangle documentation generation ( keyman visualization from config)
- [] App appendix
- [] GitHub actions test on macos on PR
- [] Aws-vault
