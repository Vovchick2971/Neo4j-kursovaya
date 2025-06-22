#!/bin/bash
set -e
echo "Настройка Red OS"
echo "Настройка сетевого интерфейса"
nmcli connection modify "Проводное подключение 1" ipv4.addresses "192.168.0.1/24" ipv4.method "manual"
echo "Перезапуск сервиса NetworkManager"
systemctl restart NetworkManager
echo "Включение IP forwarding в /etc/sysctl.conf"
grep -q '^net.ipv4.ip_forward' /etc/sysctl.conf && \
    sed -i 's/^net.ipv4.ip_forward.*/net.ipv4.ip_forward=1/' /etc/sysctl.conf || \
    echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
echo "Применение настроек sysctl"
sysctl -p
echo "Настройка маскарадинга"
iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o enp0s3 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 172.25.0.0/24 -o enp0s3 -j MASQUERADE
echo "Сохранение правил iptables в /root/rules"
iptables-save > /root/rules
