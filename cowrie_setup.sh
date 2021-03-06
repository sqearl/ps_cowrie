#!/bin/bash
# Add a repo for software-properties-common
apt-add-repository universe
# Run the updates
apt-get update -y && sudo apt-get upgrade -y
# Collect the things
apt-get install git software-properties-common python-virtualenv python-pip libmpfr-dev libcurl4-openssl-dev libssl-dev libffi-dev build-essential libpython-dev python2.7-minimal authbind -y
adduser --disabled-password --gecos "" cowrie 
cd /home/cowrie
sudo -u cowrie git clone http://github.com/micheloosterhof/cowrie
mkdir /home/cowrie/cowrie/data
cd /home/cowrie/cowrie/etc/
sudo wget https://raw.githubusercontent.com/sqearl/ps_cowrie/master/userdb.txt
sudo -u cowrie ssh-keygen -t dsa -b 1024 -f ssh_host_dsa_key
cd /home/cowrie/cowrie
sudo -u cowrie virtualenv cowrie-env/bin/activate 
echo 'requests' >> requirements.txt
sudo pip install --upgrade setuptools
sudo pip install -r requirements.txt
cd /home/cowrie/cowrie/etc/
wget https://raw.githubusercontent.com/sqearl/ps_cowrie/master/cowrie.cfg
chown cowrie:cowrie cowrie.cfg
export PYTHONPATH=/home/cowrie/cowrie/etc/
iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 2222
iptables -t nat -A PREROUTING -p tcp --dport 23 -j REDIRECT --to-port 2223
iptables-save | sudo tee /etc/iptables.conf
echo "iptables-restore < /etc/iptables.conf" >> /etc/rc.local
echo "su -c '/home/cowrie/cowrie/bin/cowrie start' -s /bin/sh cowrie" >> /etc/rc.local
sudo su cowrie -c '/home/cowrie/cowrie/bin/cowrie start'
git clone https://github.com/aplura/Tango.git /tmp/tango
cd /tmp/tango
sudo rm uf_only.sh
wget https://raw.githubusercontent.com/sqearl/Tango/master/uf_only.sh
sudo chmod +x uf_only.sh
sudo ./uf_only.sh
