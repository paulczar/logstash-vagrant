#!/bin/sh

service elasticsearch stop
initctl stop logstash
initctl stop kibana

cd /vagrant
rm -rf elasticsearch/*
rm -rf logstash/bin/* logstash/log/* logstash/data/*
rm -rf kibana/*