#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu net-tools -y
clear

echo "=+=+=+=+=+=++=+=++=crypton=+=+=+=+=+=++=+=++="                     
                      
echo -e '\e[1m\e[32m6'
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

ver="1.17.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version

cd $HOME
rm -rf masa-node-v1.0
git clone https://github.com/masa-finance/masa-node-v1.0

cd masa-node-v1.0/src
git checkout v1.03
make all

# copy binaries
cd $HOME/masa-node-v1.0/src/build/bin
sudo cp * /usr/local/bin

# init
cd $HOME/masa-node-v1.0
geth --datadir data init ./network/testnet/genesis.json


echo "=+=+=+=+=+=++=+=++=crypton=+=+=+=+=+=++=+=++="
echo -e "\e[1m\e[32m6. Enter Node name \e[0m"
read -p "Node Name : " MASA_NODENAME

echo -e "\e[1m\e[92m Node Name: \e[0m" $NODE_NAME

echo "=+=+=+=+=+=++=+=++=crypton=+=+=+=+=+=++=+=++="

tee $HOME/masad.service > /dev/null <<EOF
[Unit]
Description=MASA103
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which geth) \
  --identity ${MASA_NODENAME} \
  --datadir $HOME/masa-node-v1.0/data \
  --port 30300 \
  --syncmode full \
  --verbosity 5 \
  --emitcheckpoints \
  --istanbul.blockperiod 10 \
  --mine \
  --miner.threads 1 \
  --networkid 190260 \
  --http --http.corsdomain "*" --http.vhosts "*" --http.addr 127.0.0.1 --http.port 8545 \
  --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul \
  --maxpeers 50 \
  --bootnodes enode://91a3c3d5e76b0acf05d9abddee959f1bcbc7c91537d2629288a9edd7a3df90acaa46ffba0e0e5d49a20598e0960ac458d76eb8fa92a1d64938c0a3a3d60f8be4@54.158.188.182:21000
Restart=on-failure
RestartSec=10
LimitNOFILE=4096
Environment="PRIVATE_CONFIG=ignore"
[Install]
WantedBy=multi-user.target
EOF


sudo mv $HOME/masad.service /etc/systemd/system

sudo systemctl daemon-reload

sudo systemctl enable masad

sudo systemctl restart masad

. <(wget -qO- https://raw.githubusercontent.com/usrbad/masa-node-v1.0/main/addbootnode.sh)


