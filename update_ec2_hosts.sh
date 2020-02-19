echo 'Current hosts file'
cat /etc/hosts

echo 'Removing EC2 instances'
sed -i.bak '/ec2-/d' /etc/hosts

echo 'Removing Proxy variables'
unset http_proxy
unset https_proxy

echo 'Getting new EC2 instances data'
aws ec2 describe-instances --profile iteso --region=us-west-2 --query 'Reservations[*].Instances[*].[InstanceId,Tags[?Key==`Name`].Value|[0],State.Name,PublicDnsName,PublicIpAddress]' --output table | grep ec2 | awk '{print $9" " $7" "$3}' >> /etc/hosts 2>&1

echo 'New hosts file'
cat /etc/hosts
