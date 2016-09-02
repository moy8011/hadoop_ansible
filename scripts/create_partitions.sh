#!/bin/bash

d=1

bad_drives="$( parted -l 2>&1 | grep Error | awk '{ print $2 }' | sed 's/\://g' | sed ':a;N;$!ba;s/\n/|/g' )"
echo 'Bad drives: '$bad_drives >> ~/create_partitions.log

if [$bad_drives -ne 0 ]
then 
	output="$( parted -l 2> /dev/null | grep 'Disk /dev/sd' | awk '{ print $2 }' | cut -c-8 | grep -Ev ${bad_drives})"
else
        output="$( parted -l 2> /dev/null | grep 'Disk /dev/sd' | awk '{ print $2 }' | cut -c-8 )"
fi
echo 'Good drives: '$output >> ~/create_partitions.log

for dev in $output
do
	echo 'Device: '$dev >> ~/create_partitions.log
	part=$dev"1"
	echo 'Partition : '$part 
	echo 'Data folder: '$d >> ~/create_partitions.log

	df | grep $part

	if [ $? -ne 0 ]
	then 
		echo "Partition doesn't exist. It will be created" >> ~/create_partitions.log
		echo "Creating folder" >> ~/create_partitions.log
		mkdir -p /data/$d
		echo "Creating partition" >> ~/create_partitions.log
		sgdisk -p $dev -n 1:0:0
		echo "Formating partition" >> ~/create_partitions.log
		mkfs.ext4 -m 0 $part
		echo "Mounting partition" >> ~/create_partitions.log
		mount -t ext4 -o rw $part /data/$d
		echo "Adding partition to FSTAB" >> ~/create_partitions.log
		echo "$part /data/$d    ext4    defaults,noatime,nodiratime        0" >> /etc/fstab
		echo "Changing folder attributes" >> ~/create_partitions.log
		chmod 0757 /data/$d
		((d++))
	else
		echo "Partition already exists. Exiting now" >> ~/create_partitions.log
	fi	
done
