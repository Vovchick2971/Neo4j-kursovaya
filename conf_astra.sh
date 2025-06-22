#!/bin/bash
set -e
echo "Настройка Astra Linux"
echo "Настройка сетевого интерфейса"
cat > /etc/network/interfaces <<EOF
auto lo
iface lo inet loopback
auto enp0s9
   iface enp0s9 inet static
    	   address 172.25.0.1/24
    	   gateway 172.25.0.254
EOF
echo "Изменение /etc/resolv.conf"
echo "Перезапуск сервиса networking"
systemctl restart networking
echo "Обновление списка пакетов и установка SSH-сервера"
apt update && apt -y install openssh-server
echo "Настройка sshd_config"
sed -i 's/^#\?Port .*/Port 22/' /etc/ssh/sshd_config
sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
echo "Перезапуск sshd"
systemctl restart sshd
