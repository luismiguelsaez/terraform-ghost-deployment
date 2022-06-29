#!/usr/bin/env bash

# Disable firewall

ufw disable

# Install docker

apt-get -y update
apt-get -y upgrade
apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

apt-get -y update
apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Create content directories

mkdir -p /data/ghost/content /data/ghost/backup

# Setup application user

useradd --groups docker --comment "Application user" --create-home --shell /usr/bin/bash app
mkdir /home/app/.ssh
chmod 0700 /home/app/.ssh
cp -rp /home/ubuntu/.ssh/authorized_keys /home/app/.ssh/
chown -R app. /home/app/.ssh

chown -R app. /data/ghost

# Enable and start docker service

systemctl enable docker
systemctl start docker

# Setup crontab job

cat << EOF > /var/spool/cron/crontabs/app
0 0 * * * docker compose exec db bash -c 'mysqldump -u root -p"\${MYSQL_ROOT_PASSWORD}" ghost' | gzip -9 > /data/ghost/backup/\$(date '+%Y%m%d').sql.gz
EOF
