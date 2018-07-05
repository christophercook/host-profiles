alias ll='ls -AlF'
alias la='ll -A'

# Add color support to ip
if [ -n "$(which ip)" ]; then
  alias ip='ip -c'
fi

# Set up AWS-CLI environment
export PATH=$PATH:~/.local/bin
if [ -n "$(which aws)" ]; then
  # Enable aws auto completion
  if [ -n "$(which aws_completer)" ]; then
    complete -C "$(which aws_completer)" aws
  fi

  if [ -s ~/.aws/profile ]; then
    source ~/.aws/profile

    # TODO: support macOS keyring
    if [[ -n "$AWS_PROFILE" ]] && [[ -n "$(which secret-tool)" ]]; then
      export AWS_PROFILE

      # Check if access keys and secrets are stored in keyring
      AWS_ACCESS_KEY_ID="$(secret-tool lookup type 'AWS ACCESS KEY ID' account $AWS_PROFILE)"
      AWS_SECRET_ACCESS_KEY="$(secret-tool lookup type 'AWS SECRET ACCESS KEY' account $AWS_PROFILE)"
      if [ -n "$AWS_ACCESS_KEY_ID" ] && [ -n "$AWS_SECRET_ACCESS_KEY" ]; then
        export AWS_ACCESS_KEY_ID
        export AWS_SECRET_ACCESS_KEY
      else
        echo "Warning: no aws credentials were found in the keyring for $AWS_PROFILE"
      fi
    fi
  else
    echo "Warning: you should set a profile in ~/.aws/profile (e.g. echo username > ~/.aws/profile) and add your credentials to the keyring"
  fi
fi

### Replace Prompt

# Define prompt colors, if available.
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  if [ "$(id -u)" -eq 0 ]; then
    # Highligh root
    c_user='\[\e[1;31m\]'
  else
    c_user='\[\e[1;33m\]'
  fi

  # TODO: add support for VM hosts maybe
  if [ -f /.dockerenv ]; then
    # Highlight docker host
    c_host='\[\e[1;32m\]'
  else
    c_host='\[\e[1;33m\]'
  fi

  c_reset='\[\e[0m\]'
  c_path='\[\e[0;33m\]'
  c_git_clean='\[\e[0;00m\]'
  c_git_dirty='\[\e[0;95m\]'
else
  c_user=
  c_host=
  c_reset=
  c_path=
  c_git_clean=
  c_git_dirty=
fi

# Function to assemble the Git part of our prompt.
git_prompt ()
{
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi

  git_branch=$(git branch 2>/dev/null | sed -n '/^\*/s/^\* //p')
  git_repo=$(basename `git rev-parse --show-toplevel`)

  if git diff --quiet 2>/dev/null >&2; then
    git_color="$c_git_clean"
  else
    git_color="$c_git_dirty"
  fi

  echo "[$git_repo:$git_color$git_branch${c_reset}]"
}

# Create prompt
PROMPT_COMMAND='PS1="${c_user}\u${c_reset}@${c_host}\h${c_reset}:${c_path}\w${c_reset}$(git_prompt)\\$ "'

