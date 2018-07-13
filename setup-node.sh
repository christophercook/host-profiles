#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
   echo "This script must be run as root" 
   exit 1
fi

# Ubuntu specific
if [ "$(lsb_release -si)" = "Ubuntu" ]; then

  # Install nodejs 8.x if not found
  if [ -z "$(which node)" ]; then
    curl -sL https://deb.nodesource.com/setup_8.x | bash -
    apt-get install -y nodejs
  fi

  # Install yarn if not found
  if [ -z "$(which yarn)" ]; then
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
    apt-get update && apt-get install yarn
  fi
fi

# Suggest other npm packages to install
echo 'Suggested node packages:'
echo '  yarn global add create-react-app, serverless, typescript, vue-cli'
