if [ -f ~/.lscolors ]; then
  source ~/.lscolors
fi

alias ll='ls -AlF'
alias la='ll -A'

# Set up AWS-CLI environment
if [[ -n "$(which docker)" ]] && [[ -f ~/.aws_account ]]; then
  source ~/.aws_account
  if [[ -n "$AWS_ACCOUNT" ]] && [[ -n "$(which secret-tool)" ]]; then
    export AWS_ACCESS_KEY_ID="$(secret-tool lookup type 'AWS ACCESS KEY ID' account $AWS_ACCOUNT)"
    export AWS_SECRET_ACCESS_KEY="$(secret-tool lookup type 'AWS SECRET ACCESS KEY' account $AWS_ACCOUNT)"
    alias aws='sudo docker run --rm -t $(tty &>/dev/null && echo "-i") -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" -v "$(pwd):/project" mesosphere/aws-cli'
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

