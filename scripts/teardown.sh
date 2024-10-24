#!/bin/bash

# Stop and remove all running containers
docker rm -f open_wifi_ap open_wifi_client wpa2_wifi_ap_1 wpa2_wifi_client wpa2_wifi_ap_2 wpa3_wifi_ap >/dev/null 2>&1 || true

# Unload the mac80211_hwsim module
sudo modprobe -r mac80211_hwsim

echo "All networks and interfaces have been torn down!"
