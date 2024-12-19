# DOTFILES

ssh-keygen -a 100 -o -t rsa -b 4096 -f ~/.ssh/id_rsa
pbcopy<~/.ssh/id_rsa.pub 
ssh -T git@github.com
git remote add origin git@github.com/:GITHUB_USERNAME/dotfiles.git
git add -A .
git commit -m "Initial commit"
git push -u origin main