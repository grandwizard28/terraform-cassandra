#!/bin/bash

BUCKET_NAME=${T_BUCKET_NAME}
BUCKET_KEY=${T_BUCKET_KEY}

apt update
apt install openjdk-8-jdk awscli apt-transport-https -y

sh -c 'echo "deb http://www.apache.org/dist/cassandra/debian 40x main" > /etc/apt/sources.list.d/cassandra.list'
wget -q -O - https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -

apt update
apt install cassandra -y
systemctl enable cassandra
systemctl stop cassandra
sudo rm -rf /var/lib/cassandra/*
sleep 1m

aws s3 cp s3://$BUCKET_NAME/$BUCKET_KEY/ /etc/cassandra --recursive

systemctl start cassandra



