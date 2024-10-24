FROM ubuntu:20.04

RUN apt-get update && apt-get install -y wpasupplicant iptables

COPY wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf

CMD ["bash", "-c", "wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf & sleep infinity"]
