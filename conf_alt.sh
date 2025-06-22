#!/bin/bash
set -e
echo "Настройка Alt Linux"
echo "Настройка сетевого интерфейса"
echo "BOOTPROTO=static
TYPE=eth
NM_CONTROLLED=no
DISABLED=no" > /etc/net/ifaces/enp0s3/options
echo "192.168.0.2/24" > /etc/net/ifaces/enp0s3/ipv4address
echo "default via 192.168.0.1" > /etc/net/ifaces/enp0s3/ipv4route
echo "Перезапуск сервиса network"
systemctl restart network
echo "Добавление записей в /etc/hosts"
grep -q '172.25.0.1 astra' /etc/hosts || echo '172.25.0.1 astra' >> /etc/hosts
echo "Обновление списка пакетов и установка SSH-сервера"
apt-get update && apt-get -y install openssh-server
echo "Настройка sshd_config"
sed -i 's/^#\?Port .*/Port 22/' /etc/openssh/sshd_config
sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/openssh/sshd_config
echo "Перезапуск sshd"
systemctl restart sshd
echo "Генерация SSH-ключа"
ssh-keygen -N ""
echo "Копирование ключей на хосты alt и astra"
ssh-copy-id -o StrictHostKeyChecking=no "root@astra"
ssh-copy-id -o StrictHostKeyChecking=no "root@alt"
echo "Установка git и ansible"
apt-get -y install git ansible
