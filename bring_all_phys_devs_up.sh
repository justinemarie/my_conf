#!/bin/bash

echo "TURNING OFF CPU SCALING"
sudo bash -c "echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor"
cat /proc/cpuinfo | grep MHz

if [ $1 == "--netmap" ]
then
  echo "setting up netmap"
  sudo rmmod ixgbe
  sudo insmod /home/justine/netmap/LINUX/netmap_lin.ko
  sudo insmod /home/justine/netmap/LINUX/forcedeth.ko
  sudo insmod /home/justine/netmap/LINUX/ixgbe/ixgbe.ko #RSS=0,0,0,0,0,0,0,0,0 MQ=0,0,0,0,0,0,0,0 
  sudo cp /home/justine/netmap/examples/pkt-gen /bin
  sudo cp /home/justine/netmap/examples/vale-ctl /bin
elif [ $1 == "--dpdk" ]
then
  echo "setting up dpdk"
#  sudo /home/justine/DPDK-1.5.0/setarg 
  echo "rebinding drivers"
  sudo lspci | grep Ethernet | cut -d " " -f1 | while read line; 
    do dev=`ls /sys/devices/pci0000:*/*/0000:$line/net` 
    echo $dev $line
    sudo /home/justine/DPDK-1.5.0/tools/pci_unbind.py -b igb_uio $line && echo "OK"
  done

  exit 0
elif [ $1 == "--xennet" ]
then
  sudo rmmod ixgbe
  sudo rmmod xen_netback
  sudo rmmod xen_netfront
  sudo rmmod netmap_lin
  sudo insmod /home/justine/xennet/netmap/LINUX/netmap_lin.ko
  sudo insmod /home/justine/xennet/netmap/LINUX/forcedeth.ko
  sudo insmod /home/justine/xennet/netmap/LINUX/ixgbe/ixgbe.ko RSS=0,0,0,0,0,0,0,0,0 MQ=0,0,0,0,0,0,0,0 
  sudo insmod /home/justine/xennet/LINUX/xen-netback/xen-netback.ko

  sudo cp /home/justine/xennet/netmap/examples/vale-ctl /bin
  sudo cp /home/justine/xennet/netmap/examples/pkt-gen /bin

  sudo /home/justine/tools/set_iptables.sh
fi



echo "waking devices up (netmap/normal)"
#sudo lspci | grep Network | cut -d " " -f1 | while read line; do ls /sys/devices/pci0000:*/*/0000:$line/net; done | while read dev 

ifconfig -a | egrep -o "^[^ ]*" | while read dev
do sudo ifconfig $dev up promisc
    echo $dev
    #sudo ethtool -A $dev autoneg off rx off tx off
  done

