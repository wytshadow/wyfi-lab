#!/bin/bash

# Create a Docker network
docker network create wifi-net

# Build and run Open network AP and Client
docker build -t open_wifi_ap -f ../ap-configs/Dockerfile ../ap-configs/
docker build -t open_wifi_client -f ../client-configs/Dockerfile ../client-configs/
docker run --rm --network wifi-net --privileged --name open_wifi_ap -v $(pwd)/../ap-configs/hostapd-open.conf:/etc/hostapd/hostapd.conf -d open_wifi_ap
docker run --rm --network wifi-net --privileged --name open_wifi_client -v $(pwd)/../client-configs/wpa_supplicant-open.conf:/etc/wpa_supplicant/wpa_supplicant.conf -d open_wifi_client

# Build and run WPA2 network AP and Clients
docker build -t wpa2_wifi_ap -f ../ap-configs/Dockerfile ../ap-configs/
docker build -t wpa2_wifi_client -f ../client-configs/Dockerfile ../client-configs/
docker run --rm --network wifi-net --privileged --name wpa2_wifi_ap_1 -v $(pwd)/../ap-configs/hostapd-wpa2-1.conf:/etc/hostapd/hostapd.conf -d wpa2_wifi_ap
docker run --rm --network wifi-net --privileged --name wpa2_wifi_client -v $(pwd)/../client-configs/wpa_supplicant-wpa2.conf:/etc/wpa_supplicant/wpa_supplicant.conf -d wpa2_wifi_client

# WPA2 network with no clients
docker run --rm --network wifi-net --privileged --name wpa2_wifi_ap_2 -v $(pwd)/../ap-configs/hostapd-wpa2-2.conf:/etc/hostapd/hostapd.conf -d wpa2_wifi_ap

# Build and run WPA3 network AP
docker build -t wpa3_wifi_ap -f ../ap-configs/Dockerfile ../ap-configs/
docker run --rm --network wifi-net --privileged --name wpa3_wifi_ap -v $(pwd)/../ap-configs/hostapd-wpa3.conf:/etc/hostapd/hostapd.conf -d wpa3_wifi_ap

echo "All networks are up!"
