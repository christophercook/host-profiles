#!/bin/bash

# Check if running as root
if [ "$EUID" -eq 0 ]; then
   echo "This script shouldn't be run as root"
   exit 1
fi

# Rsync options
#  * copy sub-directories
#  * copy symlinks
#  * copy permissions and timestamps
#  * prevent overwriting existing files
#  * list skipped files
RSYNC_ARGS=" --ignore-existing --info=SKIP1 -rlpt"

# Copy common files
rsync $RSYNC_ARGS all/ $HOME/

# Detect environment
case "$(uname -s)" in
  Linux*)   host=linux;;
  Darwin*)  host=macOS;;
  CYGWIN*)  host=cygwin;;
  *)        host=UNKNOWN;;
esac

# Copy environment specific files
if [ -d "$host" ]; then
  rsync $RSYNC_ARGS $host/ $HOME/
fi

# Configure non-file specific linux preferences (needs tweaking to support non-debian distros)
if [ "$host" = "linux" ] && [ "$(lsb_release -si)" = "Ubuntu" ]; then
  if [ -n "$(which gsettings)" ]; then

    # set gnome terminal colors to tango dark scheme
    profileId=$(sed -e "s/'//g" <<<$(gsettings get org.gnome.Terminal.ProfilesList default))
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profileId/ use-theme-colors false    
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profileId/ background-color 'rgb(46,52,54)'
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profileId/ foreground-color 'rgb(211,215,207)'

    # set gedit color scheme to Monokai Extended
    gsettings set org.gnome.gedit.preferences.editor scheme 'vsdark'
  fi

  # Define the list of required repository packages, in roughly the order they should be installed
  PACKAGES=( apt-transport-https ca-certificates curl vim git unzip vlc python-pip )

  # Install base packages individually, instead of all together, so that we can check if they are
  # installed and skip if they are installed which reduces output messaging.
  echo "Preparing to install packages"
  for p in "${PACKAGES[@]}" ; do
    if [ "$(dpkg -s ${p} 2> /dev/null | grep 'Status: ')" != "Status: install ok installed" ]; then
      sudo apt-get -y install ${p}
    fi
  done

elif [ "$host" = "macOS" ]; then
  # TODO: Configure iTerm profile

  # Add bash_aliases dependency
  if [ "$(grep 'source ~/.bash_aliases' ~/.bash_profile)" != "" ]; then
    echo -e "\nif [ -f ~/.bash-aliases ]; then\n  source ~/.bash-aliases\nfi" > ~/.bash_profile
  fi
fi
