FROM ubuntu:20.04

RUN apt-get update && apt-get install -y hostapd iptables bridge-utils

COPY hostapd.conf /etc/hostapd/hostapd.conf

CMD ["bash", "-c", "hostapd /etc/hostapd/hostapd.conf & sleep infinity"]
