#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y vim nano git curl wget htop bash-completion xz-utils zip unzip ufw locales net-tools mc jq make gcc gpg build-essential ncdu sysstat
clear

echo "=+=+=+=+=+=++=+=++=crypton=+=+=+=+=+=++=+=++="                     
                      
echo -e '\e[1m\e[32m'
echo -e '   ____                           __                        '
echo -e '  /\  _`\                        /\ \__                     '
echo -e '  \ \ \/\_\  _ __   __  __  _____\ \ ,_\   ___     ___      '
echo -e '   \ \ \/_/_/\`__\/\ \/\ \/\ __ \ \ \/  //  _  \ /   _ \    '
echo -e '    \ \ \L\ \ \ \/ \ \ \_\ \ \ \L\ \ \ \_/\ \L\ \/\ \/\ \   '
echo -e '     \ \____/\ \_\  \/`____ \ \ ,__/\ \__\ \____/\ \_\ \_\  '
echo -e '      \/___/  \/_/   `/___/> \ \ \/  \/__/\/___/  \/_/\/_/  '
echo -e '                        /\___/\ \_\                         '
echo -e '                        \/__/  \/_/                         '
echo -e '\e[0m'

echo "=+=+=+=+=+=++=+=++=crypton=+=+=+=+=+=++=+=++="
sleep 2

# Установите требуемые пакеты
sudo apt install -y ca-certificates curl gnupg lsb-release # Добавьте в систему GPG-ключ Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg # Добавьте в систему репозиторий Docker
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Обновите список пакетов в репозиториях и установите Docker
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io

# Проверка установленной версии Docker
sudo docker --version

# Загружаем Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# Устанавливаем необходимые привилегии для запуска Docker Compose
sudo chmod +x /usr/local/bin/docker-compose
# Проверка установленной версии Docker Compose
docker-compose --version

# Переходим в домашнюю директорию пользователя
cd ~
# Клонируем репозиторий Masa Finance
git clone https://github.com/masa-finance/masa-node-v1.0.git

# Перейдите в рабочую директорию Masa
cd ~/masa-node-v1.0
# Запустите контейнер Masa с помощью Docker Compose
PRIVATE_CONFIG=ignore docker-compose up -d
