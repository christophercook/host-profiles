#!/bin/bash

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

#  # Set up awscli environment
#  export PATH=$PATH:~/.local/bin
#  complete -C '$HOME/.local/bin/aws_completer' aws

#  if [ -f ~/.aws/profile ] && [ -n "$(cat ~/.aws/profile)" ]; then
#    export AWS_PROFILE="$(cat ~/.aws/profile)"

    # Check if access keys and secrets are stored in keyring
#    AWS_ACCESS_KEY_ID="$(secret-tool lookup type 'AWS ACCESS KEY ID' account $AWS_PROFILE)"
#    AWS_SECRET_ACCESS_KEY="$(secret-tool lookup type 'AWS SECRET ACCESS KEY' account $AWS_PROFILE)"
#    if [ -n "$AWS_ACCESS_KEY_ID" ] && [ -n "$AWS_SECRET_ACCESS_KEY" ]; then
#      export AWS_ACCESS_KEY_ID
#      export AWS_SECRET_ACCESS_KEY
#    else
#      echo "Warning: no aws credentials were found in the keyring for $AWS_PROFILE"
#    fi
#  else
#    echo "Warning: you should set a profile in ~/.aws/profile and add your credentials to the keyring"
#  fi

else
  echo "pip must be installed first."
fi

# awscli could be run from a docker container instead
#if [[ -z "$(which aws)" ]] && [[ -n "$(which docker)" ]]; then
#  alias aws='sudo docker run --rm -t $(tty &>/dev/null && echo "-i") -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" -v "$(pwd):/project" mesosphere/aws-cli'
#fi
