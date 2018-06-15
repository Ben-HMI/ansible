#!/bin/bash

NET_SCRIPT_FOLDER="/etc/sysconfig/network-scripts/"

while [[ ! $ETH0_IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ && ! $ETH0_GW =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]];
do

	read -p "Merci de saisir l'adresse ip pour l'interface eth0 " ETH0_IP

	read -p "Merci de saisir l'adresse ip de la gateway pour l'interface eth0 " ETH0_GW

	read -p "Merci de saisir le nom de la machine" NEW_HOSTNAME
done

NEW_MAC=$(ip a s eth0 | grep ether | awk '{print $2}')

OLD_MAC=$(grep "HWADD" ${NET_SCRIPT_FOLDER}/ifcfg-eth0 | cut -d "=" -f 2)
OLD_ETH0_IP=$(grep "IPADDR" ${NET_SCRIPT_FOLDER}/ifcfg-eth0 | cut -d "=" -f 2)
OLD_ETH0_GW=$(grep "GATEWA" ${NET_SCRIPT_FOLDER}/ifcfg-eth0 | cut -d "=" -f 2)
OLD_HOSTNAME=$(hostname)

echo "Voici les modifications qui vont être apportées au fichier ifcfg-eth0 :

$OLD_MAC 	-> $NEW_MAC
$OLD_ETH0_IP 		-> $ETH0_IP
$OLD_ETH0_GW 		-> $ETH0_GW

La machine va être renommée :

$OLD_HOSTNAME 	-> $NEW_HOSTNAME"

while [[ "$COMMIT" != "y" && $COMMIT != "n" ]]
do
	read -p "Ces changements vous conviennent ? y/n " COMMIT
done

if [[ "$COMMIT" == "y" ]]; then
	sed -i "s/HWADDR=$OLD_MAC/HWADDR=$NEW_MAC/" ${NET_SCRIPT_FOLDER}/ifcfg-eth0
	sed -i "s/IPADDR0=$OLD_ETH0_IP/IPADDR0=$ETH0_IP/" ${NET_SCRIPT_FOLDER}/ifcfg-eth0
	sed -i "s/GATEWAY0=$OLD_ETH0_GW/GATEWAY0=$ETH0_GW/" ${NET_SCRIPT_FOLDER}/ifcfg-eth0
	hostnamectl set-hostname $NEW_HOSTNAME
else
	echo "Abandon"
fi

