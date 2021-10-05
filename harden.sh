#!/bin/bash
#switch to root user
sudo su -
#update, upgrade and install necessary packages
sudo apt-get update
sudo apt-get upgrade -y
sudo apt install unattended-upgrades -y
sudo apt install apt-listchanges -y
sudo unattended-upgrade -d
sudo apt install fail2ban -y

#back-up the configuration file
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

#uncomment lines from configuration file
sudo sed -i 's/# [sshd]/[sshd]/g' /etc/fail2ban/jail.conf
sudo sed -i 's/# enabled = true/enabled = true/g' /etc/fail2ban/jail.conf

#restart service
sudo systemctl restart fail2ban

#install and enable firewall
sudo apt install ufw
sudo ufw enable

#create a user with a password
useradd -s /bin/bash -m jay

sudo chpasswd << 'END'
jay:password
END
#append user to sudo group
usermod -aG sudo jay

#delete the default ubuntu user
deluser --remove-home ubuntu

#allow user run sudo commands without password
touch /etc/sudoers.d/010_jay-nopasswd
echo 'jay ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/010_jay-nopasswd
#disable root login and password authentication, permitting only keybased authentication
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
#restart service
systemctl restart sshd

#switch to user
su - jay
