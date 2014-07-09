#!/bin/sh

LOGSTASH_VERSION="1.1.9"
ES_VERSION="0.20.2"

echo Install APT Packages
	apt-get update
	apt-get -y install openjdk-7-jre-headless curl redis-server rabbitmq-server g++ git make

echo Downloading and installing logstash to /vagrant/logstash/bin/logstash-monolithic.jar
	 mkdir -p /vagrant/logstash/bin /vagrant/logstash/log /vagrant/logstash/conf.d /vagrant/logstash/conf.examples
	 wget -q -O /vagrant/logstash/bin/logstash-monolithic.jar https://logstash.objects.dreamhost.com/release/logstash-${LOGSTASH_VERSION}-monolithic.jar
	 install -o root -g root -m 0644 /vagrant/scripts/init-logstash.conf /etc/init/logstash.conf

echo Downloading and installing kibana
	mkdir -p /vagrant/kibana
	wget -q -O /tmp/kibana-ruby.tar.gz "https://github.com/rashidkpc/Kibana/tarball/kibana-ruby"
 	cd /vagrant/kibana
	tar xzvf /tmp/kibana-ruby.tar.gz --strip=1 --show-transformed-names
	rm /tmp/kibana-ruby.tar.gz
	gem install bundler
	bundle install
	sed -i "s|KibanaHost|#KibanaHost|" /vagrant/kibana/KibanaConfig.rb
	install -o root -g root -m 0644 /vagrant/scripts/init-kibana.conf /etc/init/kibana.conf

echo downloading and installing elasticsearch
	mkdir -p /vagrant/elasticsearch
	wget -q -O /tmp/elasticsearch.tar.gz http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz
	wget -q -O /tmp/es-wrapper.tar.gz "http://github.com/elasticsearch/elasticsearch-servicewrapper/tarball/master"
	cd /vagrant/elasticsearch
  	tar xzvf /tmp/elasticsearch.tar.gz --strip=1 --show-transformed-names
  	juju-log "untar elasticsearch service wrapper"
  	tar xzvf /tmp/es-wrapper.tar.gz
  	rm /tmp/es-wrapper.tar.gz
  	mv *servicewrapper*/service bin/
  	rm -Rf *servicewrapper*
  	cd /vagrant/elasticsearch
  	bin/service/elasticsearch install
	sed -i "s/\<Path to Elasticsearch Home\>/\/vagrant\/elasticsearch/" bin/service/elasticsearch.conf
  	sed -i "s/set\.default\.ES_HEAP_SIZE=.*/set.default.ES_HEAP_SIZE=512/" bin/service/elasticsearch.conf


echo Starting Services ...
	service elasticsearch start
	initctl start logstash
	initctl start kibana

echo Install ES plugins & rivers
	/vagrant/elasticsearch/bin/plugin -install mobz/elasticsearch-head
	/vagrant/elasticsearch/bin/plugin -install lukas-vlcek/bigdesk
	/vagrant/elasticsearch/bin/plugin -install elasticsearch/elasticsearch-river-rabbitmq/1.4.0
	/vagrant/elasticsearch/bin/plugin -install leeadkins/elasticsearch-redis-river/0.0.5

service elasticsearch restart
