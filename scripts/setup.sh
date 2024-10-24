#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

echo "Starting setup..."

# Load mac80211_hwsim with 11 radios
echo "Loading mac80211_hwsim with 11 radios..."
sudo modprobe -r mac80211_hwsim || true
sudo modprobe mac80211_hwsim radios=11

# Build Docker images for the AP and client containers
echo "Building Docker images..."
docker build -t open_wifi_ap -f ./ap-configs/Dockerfile-open ./ap-configs/
docker build -t wpa2_wifi_ap_1 -f ./ap-configs/Dockerfile-wpa2-1 ./ap-configs/
docker build -t wpa2_wifi_ap_2 -f ./ap-configs/Dockerfile-wpa2-2 ./ap-configs/
docker build -t wpa3_wifi_ap -f ./ap-configs/Dockerfile-wpa3 ./ap-configs/
docker build -t wifi_client -f ./client-configs/Dockerfile-client ./client-configs/

# Common Docker run options
DOCKER_RUN_OPTS="--rm --network host --privileged --cap-add=ALL -v /sys:/sys -v /run:/run -v /lib/firmware:/lib/firmware"

# Stop and remove any existing containers to avoid conflicts
echo "Stopping and removing any existing containers..."
docker rm -f open_wifi_ap open_wifi_client wpa2_wifi_ap_1 wpa2_wifi_client wpa2_wifi_ap_2 wpa3_wifi_ap >/dev/null 2>&1 || true

# Run Open network AP and Client
echo "Starting Open WiFi AP and Client..."
docker run $DOCKER_RUN_OPTS --name open_wifi_ap \
  -v $(pwd)/ap-configs/hostapd-open.conf:/etc/hostapd/hostapd.conf \
  -d open_wifi_ap

docker run $DOCKER_RUN_OPTS --name open_wifi_client \
  -v $(pwd)/client-configs/wpa_supplicant-open.conf:/etc/wpa_supplicant/wpa_supplicant.conf \
  -d wifi_client \
  sh -c "wpa_supplicant -B -i wlan5 -c /etc/wpa_supplicant/wpa_supplicant.conf && tail -f /dev/null"

# Run WPA2 network AP and Client
echo "Starting WPA2 WiFi AP 1 and Client..."
docker run $DOCKER_RUN_OPTS --name wpa2_wifi_ap_1 \
  -v $(pwd)/ap-configs/hostapd-wpa2-1.conf:/etc/hostapd/hostapd.conf \
  -d wpa2_wifi_ap_1

docker run $DOCKER_RUN_OPTS --name wpa2_wifi_client \
  -v $(pwd)/client-configs/wpa_supplicant-wpa2.conf:/etc/wpa_supplicant/wpa_supplicant.conf \
  -d wifi_client \
  sh -c "wpa_supplicant -B -i wlan7 -c /etc/wpa_supplicant/wpa_supplicant.conf && tail -f /dev/null"

# Run WPA2 network AP with no clients
echo "Starting WPA2 WiFi AP 2 with no clients..."
docker run $DOCKER_RUN_OPTS --name wpa2_wifi_ap_2 \
  -v $(pwd)/ap-configs/hostapd-wpa2-2.conf:/etc/hostapd/hostapd.conf \
  -d wpa2_wifi_ap_2

# Run WPA3 network AP with no clients
echo "Starting WPA3 WiFi AP with no clients..."
docker run $DOCKER_RUN_OPTS --name wpa3_wifi_ap \
  -v $(pwd)/ap-configs/hostapd-wpa3.conf:/etc/hostapd/hostapd.conf \
  -d wpa3_wifi_ap

# Verify running containers
echo "Verifying running containers..."
docker ps

echo "Setup complete. Lab networks are up on wlan4 to wlan10."
