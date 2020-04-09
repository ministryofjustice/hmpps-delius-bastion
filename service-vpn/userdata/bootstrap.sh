#!/usr/bin/env bash

# GENERATE CERTS example
# CA
# strongswan pki --gen -t rsa -s 4096 -f pem > ca.key
# strongswan pki --self --in ca.key --dn "C=GB, O=HMPPS, CN=VPN-CA"
# strongswan pki --self --in ca.key -f pem --dn "C=GB, O=HMPPS, CN=VPN-CA" --ca > ca.cert
# Server
# strongswan pki --gen -t rsa -s 4096 -f pem > server.key
# strongswan pki --issue --in server.key -f pem --type priv --cacert ca.cert --cakey ca.key --dn "C=GB, O=HMPPS, CN=server" --san server > server.cert



logger "bootstrap start"
# packages
yum install epel-release -y
yum install -y python-pip git strongswan
pip install ansible
pip install awscli boto3

logger "setup stage complete"

# certs
# STORED IN SSM: /manually/created/engineering/prod/hmpss/vpn
strongswan pki --gen -t rsa -s 4096 -f pem > $HOME/ca.key
strongswan pki --self --in $HOME/ca.key -f pem --dn "C=GB, O=HMPPS, CN=VPN-CA" --ca > $HOME/ca.cert
strongswan pki --gen -t rsa -s 4096 -f pem > $HOME/server.key
strongswan pki --issue --in $HOME/server.key -f pem --type priv --cacert $HOME/ca.cert --cakey $HOME/ca.key \
    --dn "C=GB, O=HMPPS, CN=server" --san server > $HOME/server.cert

export VPN_CA_CERT="$(cat $HOME/ca.cert)"
export VPN_CERT="$(cat $HOME/server.cert)"
export VPN_KEY="$(cat $HOME/server.key)"

# galaxy install
cat << EOF > /tmp/requirements.yml
---
  - src: https://github.com/hukuruio/ansible-role-strongswan.git
EOF

ansible-galaxy install -f -r /tmp/requirements.yml

logger "galaxy setup stage complete"
#

cat << EOF > /tmp/bootstrap.yml
---
- hosts: localhost
  become: true
  vars:
    - ssl_key: "{{ lookup('env', 'VPN_KEY') }}"
    - ssl_cert: "{{ lookup('env', 'VPN_CERT') }}"
    - ssl_ca: "{{ lookup('env', 'VPN_CA_CERT') }}"
    - strongswan_cert_domain: server
    - strongswan_right_source_ip: ${vpn_cidr_block}
  roles:
    - ansible-role-strongswan
EOF

ansible-playbook /tmp/bootstrap.yml | logger

logger "bootstrap complete"

# iptables
iptables -F
iptables -Z

iptables -P INPUT DROP
iptables -P FORWARD DROP

iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp -m state --state NEW -m comment --comment ssh -m tcp --dport 22 -j ACCEPT

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

iptables -A INPUT -p udp --dport 500 -m comment --comment ike -j ACCEPT
iptables -A INPUT -p udp --dport 4500 -m comment --comment nat-traversal -j ACCEPT
iptables -A INPUT -p esp -m comment --comment esp-protocol -j ACCEPT
iptables -A INPUT -p ah -m comment --comment ah-protocol -j ACCEPT

iptables -I FORWARD 1 -o eth0 -j ACCEPT
iptables -A FORWARD -s ${network_cidr_block} -j ACCEPT

iptables-save > /etc/sysconfig/iptables
