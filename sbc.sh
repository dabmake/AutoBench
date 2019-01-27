#!/bin/bash

userid=$USER

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
apt-get update
version="$(lsb_release -c -s)" 

# set if not given as argument
if [ $version == "bionic" ]; then
	rosversion=melodic
fi
#no spaces in assignment!!!

if [ $version == "xenial" ]; then
	rosversion=kinetic
fi
echo "Installing:"  $rosversion   


apt-get install -y ros-$rosversion-desktop-full
rosdep init
sudo --user=$userid rosdep update
