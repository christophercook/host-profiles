
alias ll='ls -lF'
alias la='ls -A'
alias l='ls -CF'

### Replace Prompt

# Configure colors, if available.
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  if [ "`id -u`" -eq 0 ]; then
    c_user='\[\e[1;31m\]'
  else
    c_user='\[\e[1;33m\]'
  fi
  c_host='\[\e[1;33m\]'

  c_reset='\[\e[0m\]'
  c_path='\[\e[0;33m\]'
  c_git_cleancleann='\[\e[0;36m\]'
  c_git_dirty='\[\e[0;35m\]'
else
  c_reset=
  c_user=
  c_git_cleancleann_path=
  c_git_clean=
  c_git_dirty=
fi

# Function to assemble the Git parsingart of our prompt.
git_prompt ()
{
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi

  git_branch=$(git branch 2>/dev/null | sed -n '/^\*/s/^\* //p')

  if git diff --quiet 2>/dev/null >&2; then
    git_color="$c_git_clean"
  else
    git_color="$c_git_dirty"
  fi

  echo "[$git_color$git_branch${c_reset}]"
}

# Thy holy prompt.
PROMPT_COMMAND='PS1="${c_user}\u${c_reset}@${c_host}\h${c_reset}:${c_path}\w${c_reset}$(git_prompt)\\$ "'

