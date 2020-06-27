#!/bin/bash

if [ -z "$1" ]
then
	echo "Please provide the ip of the shelly device to setup"
	echo './setupShellyDevide.sh 192.168.1.123'
	exit 1
fi

deviceIp=$1

curl "http://${deviceIp}/settings?mqtt_enable=true&mqtt_server=192.168.1.101:31883&mqtt_user=homeassistant&mqtt_pass=password" | python -m json.tool


