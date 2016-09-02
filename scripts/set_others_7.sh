yum install ntp ntpdate -y
systemctl stop firewalld
systemctl disable firewalld
systemctl stop NetworkManager
systemctl disable NetworkManager
systemctl start ntpd
systemctl enable ntpd.service
sed -i "s/SELINUX=.*/SELINUX=disabled/g" /etc/selinux/config
sysctl vm.swappiness=1
grep "vm.swappiness" /etc/sysctl.conf  &&  sed -i "s/vm.swappiness.*/vm.swappiness = 1/g" /etc/sysctl.conf  ||  echo "vm.swappiness = 1" >> /etc/sysctl.conf
