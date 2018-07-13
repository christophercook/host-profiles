#!/bin/bash

# Check if running as root
if [ "$EUID" -eq 0 ]; then
   echo "This script shouldn't be run as root" 
   exit 1
fi

# AWS access keys can be stored in the keyring and loaded into environment
# variables to make it unneccessary to store them unencrypted in the awscli
# configuration.

# In Ubuntu key ids and secrets can be added to the
# keyring with the secret-tool

# AWS_PROFILE="<iam_user>@<aws_account>"
# echo "$AWS_PROFILE" > ~/.aws/profile
# secret-tool store --label='AWS ACCESS KEY ID for $AWS_PROFILE' \
#   type 'AWS ACCESS KEY ID' account $AWS_PROFILE
# secret-tool store --label='AWS SECRET ACCESS KEY for $AWS_PROFILE' \
#   type 'AWS SECRET ACCESS KEY' account $AWS_PROFILE

if [ -n "$(which pip)" ];then

  # Install awscli
  if [ ! -f ~/.local/bin/aws ]; then
    pip install awscli --upgrade --user
  fi

  # Re-load environment to detect awscli
  source ~/.bash_aliases

else
  echo "pip must be installed first."
fi

# awscli could be run from a docker container instead
#if [[ -z "$(which aws)" ]] && [[ -n "$(which docker)" ]]; then
#  alias aws='sudo docker run --rm -t $(tty &>/dev/null && echo "-i") -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" -v "$(pwd):/project" mesosphere/aws-cli'
#fi
