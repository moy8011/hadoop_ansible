yum install ntp ntpdate -y
systemctl stop firewalld
systemctl disable firewalld
systemctl stop NetworkManager
systemctl disable NetworkManager
systemctl start ntpd
systemctl enable ntpd.service

tuned-adm off
tuned-adm list
systemctl stop tuned
systemctl disable tuned

sed -i "s/SELINUX=.*/SELINUX=disabled/g" /etc/selinux/config

sudo sysctl -w vm.swappiness=1
