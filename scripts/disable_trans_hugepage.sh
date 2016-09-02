echo never > /sys/kernel/mm/transparent_hugepage/defrag
grep "transparent_hugepage" /etc/rc.local  &&  sed -i "s|.*transparent_hugepage.*|echo never > /sys/kernel/mm/transparent_hugepage/defrag|g" /etc/rc.local  ||  echo "echo never > /sys/kernel/mm/transparent_hugepage/defrag" >> /etc/rc.local
