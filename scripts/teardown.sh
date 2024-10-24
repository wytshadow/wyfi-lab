#!/bin/bash

# Stop and remove all containers
docker stop open_wifi_ap open_wifi_client wpa2_wifi_ap_1 wpa2_wifi_client wpa2_wifi_ap_2 wpa3_wifi_ap

# Remove the Docker network
docker network rm wifi-net

echo "All networks have been torn down!"
