#!/bin/bash

userid=$USER
sudo cp /etc/sudoers /etc/sudoers.backup
sudo cat /etc/sudoers | sudo sed -i 's/env_reset.*$/env_reset,timestamp_timeout=50/'  /etc/sudoers


echo "Changed sudoers to increase timeout"

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt-get update
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


sudo apt-get install -y ros-$rosversion-desktop-full
 

sudo rosdep init

rosdep update

echo "source /opt/ros/$rosversion/setup.bash" >> ~/.bashrc

source ~/.bashrc

echo "Installed:" $rosversion

sudo apt-get install -y python-rosinstall python-rosinstall-generator python-wstool build-essential

echo "Cloning Phoronix Test Suite"

git clone https://github.com/phoronix-test-suite/phoronix-test-suite.git
 
sudo apt-get install -y php-cli php-xml

cd phoronix-test-suite

sudo ./install-sh    

cd ~/.phoronix-test-suite/test-suites

git clone https://github.com/dabmake/MakeBench.git

cd MakeBench

mv single-board-computer/suite-definition.xml ./

cd ~

PTS_SILENT_MODE=1 phoronix-test-suite benchmark MakeBench

