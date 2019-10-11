#!/bin/bash
deviceIp='192.168.1.171'

curl "http://${deviceIp}/settings?mqtt_enable=true&mqtt_server=192.168.1.101:31883&mqtt_user=homeassistant&mqtt_pass=password"

