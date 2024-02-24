#!/bin/bash

# Only written for macos for now
brew install ansible
ansible-playbook ~/.bootstrap/setup.yml --ask-become-pass
echo "Ansible installation complete."
