#!/usr/bin/env bash
NEW_HOSTNAME="$1"
sudo hostnamectl set-hostname "$NEW_HOSTNAME"
grep 'HOSTNAME' /etc/sysconfig/network && sed -i "s/HOSTNAME=.*/HOSTNAME=$NEW_HOSTNAME/" /etc/sysconfig/network || echo "HOSTNAME=$NEW_HOSTNAME" >> /etc/sysconfig/network
