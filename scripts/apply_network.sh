#!/usr/bin/env bash

#####  Usage
# Assign static IP while connecting to dhcp-assigned IP
# ssh 192.168.1.xx ip addr
# scp apply_network.sh 192.168.1.xx:
# ssh 192.168.1.xx ./apply_network.sh eno49 10.xxx.xxx.xxx 255.255.255.0 10.xxx.xxx.xxx 10.xxx.xx.xxx   

# ./apply_network.sh eno49 10.xxx.xxx.x 255.255.255.0 10.xxx.xxx.xxx 10.xxx.xxx.xxx

NIC=$1
GATEWAY=$2
MASK=$3
DNS=$4
IP=$5

echo 'NIC: '$NIC
echo 'GATEWAY: '$GATEWAY
echo 'MASK: '$MASK
echo 'DNS: '$DNS
echo 'IP: '$IP


echo '*************  NIC file before'
echo "cat /etc/sysconfig/network-scripts/ifcfg-$NIC"
cat /etc/sysconfig/network-scripts/ifcfg-$NIC
#cat /etc/sysconfig/network-scripts/route-$NIC
echo '*************  DNS file before'
echo "cat /etc/resolv.conf"
cat /etc/resolv.conf
echo '*************  Network file before'
echo "cat /etc/sysconfig/network"
cat /etc/sysconfig/network

echo '*************  Modifying files'

#------ NIC Config
grep "IPADDR=" /etc/sysconfig/network-scripts/ifcfg-$NIC  &&  sed -i "s/IPADDR=.*/IPADDR=$IP/g" /etc/sysconfig/network-scripts/ifcfg-$NIC  ||  echo "IPADDR=$IP" >> /etc/sysconfig/network-scripts/ifcfg-$NIC
grep "NETMASK=" /etc/sysconfig/network-scripts/ifcfg-$NIC  &&  sed -i "s/NETMASK=.*/NETMASK=$MASK/g" /etc/sysconfig/network-scripts/ifcfg-$NIC  ||  echo "NETMASK=$MASK" >> /etc/sysconfig/network-scripts/ifcfg-$NIC
grep "ONBOOT=" /etc/sysconfig/network-scripts/ifcfg-$NIC  &&  sed -i "s/ONBOOT=.*/ONBOOT=yes/g" /etc/sysconfig/network-scripts/ifcfg-$NIC  ||  echo "ONBOOT=yes" >> /etc/sysconfig/network-scripts/ifcfg-$NIC
grep "BOOTPROTO=" /etc/sysconfig/network-scripts/ifcfg-$NIC  &&  sed -i "s/BOOTPROTO=.*/BOOTPROTO=none/g" /etc/sysconfig/network-scripts/ifcfg-$NIC  ||  echo "BOOTPROTO=none" >> /etc/sysconfig/network-scripts/ifcfg-$NIC
grep "NM_CONTROLLED=" /etc/sysconfig/network-scripts/ifcfg-$NIC  &&  sed -i "s/NM_CONTROLLED=.*/NM_CONTROLLED=no/g" /etc/sysconfig/network-scripts/ifcfg-$NIC  ||  echo "NM_CONTROLLED=no" >> /etc/sysconfig/network-scripts/ifcfg-$NIC
#grep "IPV6INIT=" /etc/sysconfig/network-scripts/ifcfg-$NIC  &&  sed -i "s/IPV6INIT=.*/IPV6INIT=no/g" /etc/sysconfig/network-scripts/ifcfg-$NIC  ||  echo "IPV6INIT=no" >> /etc/sysconfig/network-scripts/ifcfg-$NIC

sed -i '/IPV6/d' /etc/sysconfig/network-scripts/ifcfg-$NIC 

#------  GATEWAY
grep "GATEWAY=" /etc/sysconfig/network  &&  sed -i "s/GATEWAY=.*/GATEWAY=$GATEWAY/g" /etc/sysconfig/network  ||  echo "GATEWAY=$GATEWAY" >> /etc/sysconfig/network

#-------  DNS
grep "nameserver" /etc/resolv.conf  &&  sed -i "s/.*nameserver.*/nameserver $DNS/g" /etc/resolv.conf  ||  echo "nameserver $DNS" >> /etc/resolv.conf

#------- Others
#echo 'NETWORK=10.1.2.0' >> /etc/sysconfig/network-scripts/ifcfg-$NIC
#echo '0.0.0.0/0 via 10.1.2.254 dev eth0' >> /etc/sysconfig/network-scripts/route-$NIC
#chmod 0644 /etc/sysconfig/network-scripts/route-$NIC
#echo 'nameserver 8.8.8.8' >> /etc/resolv.conf
#echo 'nameserver 8.8.8.8' >> /etc/resolv.conf

#------------
ifdown $NIC
ifup $NIC
ethtool $NIC
ifconfig

#------------
echo '*************  NIC file after'
cat /etc/sysconfig/network-scripts/ifcfg-$NIC
#cat /etc/sysconfig/network-scripts/route-$CARD
echo '*************  DNS file after'
cat /etc/resolv.conf
echo '*************  Network file after'
cat /etc/sysconfig/network

service network restart
