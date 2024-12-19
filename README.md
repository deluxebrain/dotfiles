# DOTFILES

## Prerequisites

````sh
ssh-keygen -a 100 -o -t rsa -b 4096 -f ~/.ssh/id_rsa
pbcopy<~/.ssh/id_rsa.pub
ssh -T git@github.com#


## Create new dotfiles repo

```sh
chezmoi cd # enter source directory
git remote add origin git@github.com/:$GITHUB_USERNAME/dotfiles.git
git add -A .
git commit -m "Initial commit"
git push -u origin main
```sh

## Apply existing dotfiles

See [chezmoi init](https://www.chezmoi.io/reference/commands/init/)

By default, if repo is given, chezmoi will guess the full git repo URL, using HTTPS by default, or SSH if the --ssh option is specified, assuming the repository name is dotfiles.

```sh
# remove existing managed dotfiles if required
chezmoi init --purge

# checkout the dotfiles repo
chezmoi init $GITHUB_USERNAME

# check what will change
chezmoi diff

# apply the changes
chezmoi apply
````
