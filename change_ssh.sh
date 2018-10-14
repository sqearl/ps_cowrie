#/bin/bash
echo "Change ssh to port: "
read newport 
sed -i.bak 's/^\(Port \).*/\1'$newport'/' /etc/ssh/sshd_config
sudo service ssh restart
echo "Please reconnect to this host on the new SSH port before installing cowrie"