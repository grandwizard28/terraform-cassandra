#!/bin/bash

BUCKET_NAME=${T_BUCKET_NAME}
BUCKET_KEY=${T_BUCKET_KEY}

function start_cassandra(){
    systemctl enable cassandra
    systemctl start cassandra
}

function download_config(){
    aws s3 cp s3://$BUCKET_NAME/$BUCKET_KEY/ /etc/cassandra --recursive
}

function stop_cassandra(){
    systemctl stop cassandra
    sudo rm -rf /var/lib/cassandra/*
}

function install_cassandra(){
    sh -c 'echo "deb http://www.apache.org/dist/cassandra/debian 40x main" > /etc/apt/sources.list.d/cassandra.list'
    wget -q -O - https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -
    apt update
    apt install cassandra -y
}

function install_dependencies(){
    apt update
    apt install openjdk-8-jdk awscli apt-transport-https -y
}

function main(){
    install_dependencies
    install_cassandra
    stop_cassandra
    sleep 1m
    download_config
    start_cassandra
}

main "@"