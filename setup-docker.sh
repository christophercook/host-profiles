#!/bin/bash

# Check if running as root
if [ $(id -u) -ne 0 ]; then
   echo "This script must be run as root" 
   exit 1
fi

# Ubuntu specific
if [ "$(lsb_release -si)" = "Ubuntu" ]; then

  # Add docker repository if not found
  if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable edge" | tee /etc/apt/sources.list.d/docker-ce.list
    apt-get update && apt-get install -y docker-ce docker-compose
  fi

  # Define the list of required repository packages, in roughly the order they should be installed
  PACKAGES=( software-properties-common pass libsecret-tools \
    gnome-keyring docker-ce docker-compose )

  # Install base packages individually, instead of all together, so that we can check if they are
  # installed and skip if they are installed which reduces output messaging.
  for p in "${PACKAGES[@]}" ; do
    if [ "$(dpkg -s ${p} 2> /dev/null | grep 'Status: ')" != "Status: install ok installed" ]; then
      apt-get -y install ${p}
    fi
  done

  # Initialize docker daemon
  if [ -z "$(systemctl status docker | grep '; enabled;')" ]; then
    systemctl enable docker
  fi
  if [ -z "$(systemctl status docker | grep 'Active: active')" ]; then
    systemctl start docker
  fi

  # TODO: fix credentials helper if image publishing is required
  # Install docker credentials helper
  #if [ -z "$(which docker-credentials-pass)" ]; then
  #  wget https://github.com/docker/docker-credential-helpers/releases/download/v0.6.0/docker-credential-pass-v0.6.0-amd64.tar.gz
  #  tar -xf docker-credential-pass-v0.6.0-amd64.tar.gz
  #  rm docker-credentials-pass-v0.6.0-amd.tar.gz
  #  chmod +x docker-credential-pass
  #  mv docker-credential-pass /usr/local/bin/
  #fi

fi
