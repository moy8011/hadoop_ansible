#!/bin/bash
userName=$1
echo "User: "$userName
userPass=$2
echo "Password: "$userPass

echo "Assigning password to user"
echo $userPass | passwd $userName --stdin
