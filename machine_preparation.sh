#!/bin/bash
set -e

#This script is designed so that it could be run on a completely fresh Ubuntu machine and result in the machine having everything it needs to run 
# The Warrior Wiki docker images.

#Install Prerequisites
apt-get -y update
apt-get -y upgrade
apt-get install -y git openssl apt-transport-https wget tar

#Install Docker (https://docs.docker.com/engine/installation/ubuntulinux/)
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
rm -f /etc/apt/sources.list.d/docker.list
echo "deb https://apt.dockerproject.org/repo ubuntu-${UBUNTU_VERSION_CODENAME} main" > "/etc/apt/sources.list.d/docker.list"
apt-get -y update
apt-get purge lxc-docker*
apt-get install -y docker-engine
service docker start