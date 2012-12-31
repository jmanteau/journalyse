#!/bin/bash
#
# jmanteau 31.12.2012
#
# GPL
#

VERSION="1.0"

#=============================================================================

# Variables globales
#-------------------

WGET="wget -m --no-check-certificate"
DATE=`date +"%Y%m%d%H%M%S"`
LOG_FILE="/tmp/journlyse-$DATE.log"
APT="aptitude -q -y"


# Fonctions
#---------------------------------

displaymessage() {
  echo "$*"
}

displaytitle() {
  displaymessage "------------------------------------------------------------------------------"
  displaymessage "$*"
  displaymessage "------------------------------------------------------------------------------"
}

displayerror() {
  displaymessage "$*" >&2
}

# Premier parametre: ERROR CODE
# Second parametre: MESSAGE
displayerrorandexit() {
  local exitcode=$1
  shift
displayerror "$*"
  exit $exitcode
}

# Premier parametre: MESSAGE
# Autres parametres: COMMAND
displayandexec() {
  local message=$1
  echo -n "[In progress] $message"
  shift
echo ">>> $*" >> $LOG_FILE 2>&1
  sh -c "$*" >> $LOG_FILE 2>&1
  local ret=$?
  if [ $ret -ne 0 ]; then
echo -e "\r\e[0;31m [ERROR]\e[0m $message"
  else
echo -e "\r\e[0;32m [OK]\e[0m $message"
  fi
return $ret
}

# Start
#-------------------

# are you root ?
if [ $EUID -ne 0 ]; then
displayerror 1 "You have to be root: # su - -c $0"
fi

# Log
echo "Starting" > $LOG_FILE

displaytitle "-- Update Aptitude"
displayandexec "Disable CDROM repo" sed -i 's/^deb cdrom/#deb cdrom/g' /etc/apt/sources.list
displayandexec "Downloading puppet repo" wget http://apt.puppetlabs.com/puppetlabs-release-wheezy.deb
displayandexec "Adding Puppet Repo" dpkg -i puppetlabs-release-wheezy.deb
displayandexec "aptitude update" $APT update
displayandexec "aptitude upgrade" $APT upgrade
displayandexec "Install Puppet/Unzip" $APT install puppet unzip


displaytitle "-- Configuration Download"
displayandexec "Downloading puppet configuration" wget --no-check-certificate https://github.com/jmanteau/journalyse/archive/master.zip

unzip master.zip
puppet apply --modulepath=journalyse-master/puppet-manifests/modules/ journalyse-master/puppet-manifests/manifests/site.pp
displaymessage ""
displaymessage " ### END ###"

echo "End" >> $LOG_FILE
