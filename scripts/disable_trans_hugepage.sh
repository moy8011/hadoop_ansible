echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/enabled

grep "transparent_hugepage" /etc/rc.d/rc.local  &&  sed -i "s|.*transparent_hugepage.*|echo never > /sys/kernel/mm/transparent_hugepage/defrag|g" /etc/rc.d/rc.local  ||  echo "echo never > /sys/kernel/mm/transparent_hugepage/defrag" >> /etc/rc.d/rc.local

chmod +x /etc/rc.d/rc.local

grep "transparent_hugepage" /etc/default/grub  && sed -i 's/transparent_hugepage=\(madvise\|always\)/transparent_hugepage=never/' /etc/default/grub || sed -i 's|^\(GRUB_CMDLINE_LINUX=".*\)"$|\1 transparent_hugepage=never"|' /etc/default/grub

grub2-mkconfig -o /boot/grub2/grub.cfg

