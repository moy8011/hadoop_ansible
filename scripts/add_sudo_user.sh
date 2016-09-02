#!/bin/bash
userName=$1
echo "User: "$userName
userPass=$2
echo "Password: "$userPass

echo "Creating user $userName"
sudo adduser $userName
echo "Assigning password to user"
echo $userPass | passwd $userName --stdin
grep "$userName" /etc/sudoers  &&  sed -i "s/$userName.*/$userName    ALL=(ALL)    ALL/g" /etc/sudoers || echo "$userName    ALL=(ALL)    ALL" | sudo tee -a /etc/sudoers
