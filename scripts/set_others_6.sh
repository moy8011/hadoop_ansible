yum install ntp ntpdate ntp-doc -y
chkconfig ntpd on
chkconfig iptables off
/etc/init.d/iptables stop
service ntpd start
sed -i "s/SELINUX=.*/SELINUX=disabled/g" /etc/selinux/config
sysctl vm.swappiness=1
grep "vm.swappiness" /etc/sysctl.conf  &&  sed -i "s/vm.swappiness.*/vm.swappiness = 1/g" /etc/sysctl.conf  ||  echo "vm.swappiness = 1" >> /etc/sysctl.conf
