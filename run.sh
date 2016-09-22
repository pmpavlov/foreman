#!/bin/bash

echo "$FOREMAN_SERVER_IP $FOREMAN_SERVER_HOSTNAME" >> /etc/hosts

# Fix the hostname problem by removing that check and setting a dummy FQDN:
rm -f /usr/share/foreman-installer/checks/hostname.rb
export FACTER_fqdn="foreman.sainsburys.co.uk" # Dummy/temp FQDN

# no foreman install log? run forman installer
if [ ! -f /var/log/foreman-install.log ]; then 
  if [ -f /etc/foreman-installer/scenarios.d/katello-answers.yaml ]; then
    echo 'Answers found, starting quiet install Foreman with Katello'
    foreman-installer --scenario katello
    if [ $? -ne 0 ]; then exit $?; fi
  else
    echo 'Starting interactive installer'
    foreman-installer -i
    if [ $? -ne 0 ]; then exit $?; fi
  fi
fi
