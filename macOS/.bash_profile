# ENVIRONMENT VARIABLES

# add my ~/bin dir to path
PATH=${PATH}:~/bin
export PATH

# add aliases and custom prompt
if [ -f ~/.bash_aliases ]; then
  source ~/.bash_aliases
fi

# enable Terminal color
export CLICOLOR=1

# set EDITOR to vim
export EDITOR=vim

