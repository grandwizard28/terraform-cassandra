#!/bin/bash

BUCKET_NAME=${T_BUCKET_NAME}
BUCKET_KEY=${T_BUCKET_KEY}

function start_cassandra(){
    systemctl enable cassandra
    systemctl start cassandra
}

function set_config(){
    local private_ip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
    echo "private_ip : $private_ip"
    sed -i "s/@@LISTEN_ADDRESS@@/$private_ip/g" /etc/cassandra/cassandra.yaml
    local listen_address=$(cat /etc/cassandra/cassandra.yaml | grep listen_address)
    echo "cassandra.yaml : $listen_address"
}

function download_config(){
    aws s3 cp s3://$BUCKET_NAME/$BUCKET_KEY/ /etc/cassandra --recursive
}

function stop_cassandra(){
    echo "Stopping cassandra"
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
    set_config
    start_cassandra
}

main "@"