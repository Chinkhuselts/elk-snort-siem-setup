# Setup Guide: ELK + Snort Network Security SIEM

This guide walks through the installation and integration of Snort with the ELK Stack (Elasticsearch, Logstash, Kibana) to create a functional SIEM environment.

---

## 1. Prerequisites

- Ubuntu 20.04 VM
- Root/sudo access
- Internet connectivity
- 4GB+ RAM recommended

---

## 🛠 2. Install ELK Stack

### Install Elasticsearch

```bash
sudo apt update
sudo apt install elasticsearch
sudo systemctl enable --now elasticsearch

### Install Logstash

sudo apt install logstash
sudo systemctl enable --now logstash

## Install Kibana

sudo apt install kibana
sudo systemctl enable --now kibana

Visit Kibana: http://localhost:5601
## 3. Install Snort

sudo apt install snort

Configure interface and rules in /etc/snort/snort.conf.

### Run Snort:

sudo snort -c /etc/snort/snort.conf -i eth0 -A fast -l /var/log/snort

## 4. Configure Logstash for Snort

Edit or create a pipeline config: logstash/snort.conf

Example input/output/filter:

input {
  file {
    path => "/var/log/snort/alert_fast.txt"
    start_position => "beginning"
  }
}

filter {
  grok {
    match => { "message" => "\[\*\*\] \[%{DATA:snort_id}\] %{DATA:alert_msg} \[\*\*\]" }
  }
}

output {
  elasticsearch {
    hosts => ["localhost:9200"]
    index => "snort-alerts"
  }
}

Enable pipeline in /etc/logstash/pipelines.yml.

## 5. Test It

    Run scripts/start.sh

    Generate test traffic (e.g., nmap, ping)

    Check Kibana dashboard for alerts

## 6. Troubleshooting

    Check /var/log/logstash/ and Kibana console for parsing errors.

    Verify that Snort logs are updating.

    Confirm Elasticsearch index (snort-alerts) is receiving documents.

## Next Steps

    Add Wazuh agent for host logs

    Set up alerting (Slack, Email)

    Build detection rules for lateral movement or brute force

Author Chinkhuselts
