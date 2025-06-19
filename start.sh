#!/bin/bash

echo " Starting Snort IDS..."
sudo snort -c /etc/snort/snort.conf -i eth0 -A fast -l /var/log/snort &

echo " Starting Logstash..."
sudo systemctl start logstash

echo " Starting Elasticsearch..."
sudo systemctl start elasticsearch

echo " Starting Kibana..."
sudo systemctl start kibana

echo " ELK + Snort SIEM is now running. Check localhost:5601"
