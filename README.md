# Logstash Vagrant Environment #

I've been doing a lot of logstash testing recently and find myself constantly building VMs for it.  No longer!     

install_logstash.sh will download and install logstash, elasticsearch, and kibana into /vagrant/   This allows you to access these files from your desktop OS so you can use a friendly text editor.    

# Usage #

## Install ##

_requires vagrant, and a vagrant box:_ __precise64__

    git clone git://github.com/paulczar/logstash-vagrant.git
    cd logstash-vagrant
    vagrant up

## Use ##

Kibana - http://localhost:5601
Elastic Search - http://localhost:9200

## Modify ##

_don't forget to restart the logstash service if you're messing with configs_

    vagrant ssh
    sudo initctl restart logstash
    exit

## Destroy ##

_cleanup.sh will help clean dirs if you want to submit to github_

	vagrant ssh
	sudo /vagrant/scripts/cleanup.sh
	exit
	vagrant destroy

# Todo #

* switch from shell provisioner to chef or puppet
* add example logstash configs
