#!/bin/bash
# This is my personal script to set up everything the way I want it.

# REBOOT SCRIPTS PETER
sudo mv /sbin/reboot /sbin/reboot2
sudo cp reboot /sbin/reboot

## Packages
sudo apt-get update
sudo apt-get install ruby subversion build-essential libpcap0.8-dev vim cmake perl lvm2 python-software-properties python-dev ethtool curl colormake

sudo gem install trollop

wget http://prdownloads.sourceforge.net/ibmonitor/ibmonitor-1.4.tar.gz
tar -xf ibmonitor-1.4.tar.gz

## Set up my keys
mkdir ~/.ssh
cp id_rsa.pub ~/.ssh/authorized_keys

## Bashrc, vimrc, bash profile
cp bashrc ~/.bashrc
cp vimrc ~/.vimrc
cp bash_profile ~/.bash_profile

## Set up git
git config --global user.name "Justine Sherry"
git config --global user.email sherry@nefeli.io
git config --global core.editor vim
git config --global push.default simple 
