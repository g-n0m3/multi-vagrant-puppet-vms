#!/usr/bin/env bash

# Run on VM to bootstrap Puppet Agent nodes

if ps aux | grep "puppet agent" | grep -v grep 2> /dev/null
then
    echo "Puppet Agent is already installed. Moving on..."
else
    sudo apt-get install -yq puppet
fi

if cat /etc/crontab | grep puppet 2> /dev/null
then
    echo "Puppet Agent is already configured. Exiting..."
else
    sudo apt-get update -yq && sudo apt-get upgrade -yq

    sudo puppet resource cron puppet-agent ensure=present user=root minute=30 \
        command='/usr/bin/puppet agent --onetime --no-daemonize --splay'

    sudo puppet resource service puppet ensure=running enable=true

    # Configure /etc/hosts file
    echo "" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "# Host config for Puppet Master and Agent Nodes" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "10.1.10.10   puppet.example.com  puppet" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "10.1.10.20   lb1.example.com     lb1"    | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "10.1.10.30   app1.example.com    app1"   | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "10.1.10.40   db1.example.com     db1"    | sudo tee --append /etc/hosts 2> /dev/null 
 
    # Add agent section to /etc/puppet/puppet.conf
    echo "" && echo "[agent]\nserver=puppet" | sudo tee --append /etc/puppet/puppet.conf 2> /dev/null

    sudo puppet agent --enable

    # Install some initial puppet modules
    sudo puppet module install puppetlabs-ntp
    sudo puppet module install garethr-docker
    sudo puppet module install puppetlabs-git
    sudo puppet module install garystafford-fig

fi
