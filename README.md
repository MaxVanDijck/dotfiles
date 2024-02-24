# dotfiles
Dotfiles and other configuration that is stored accross devices

## Setup
First you will have to install [XCode](https://developer.apple.com/xcode) and [Brew](https://github.com/TechDufus/dotfiles/blob/main/bin/dotfiles).
```bash
brew install ansible
git clone git@github.com:MaxVanDijck/dotfiles.git 
cd dotfiles
ansible-playbook ansible/brew-packages.yml
stow .
```

