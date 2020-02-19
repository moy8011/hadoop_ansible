
echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" > hosts_iteso
echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> hosts_iteso
echo "" >> hosts_iteso
aws ec2 describe-instances --profile iteso --region=us-west-2 --query 'Reservations[*].Instances[*].[InstanceId,Tags[?Key==`Name`].Value|[0],State.Name,PublicDnsName,PublicIpAddress,PrivateIpAddress]' --filters Name=instance-state-name,Values=running --output table | grep ec2 | awk '{print $11 "  " $3".example.com  " $3}' >> hosts_iteso

cat hosts_iteso
