#!/bin/bash
# Simple Proxy VPN
# Script by UnknownDEV
# Cracked by Blrx

# Check if root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

#Variable Puertos
default_int="$(ip route list |grep default |grep -o -P '\b[a-z]+\d+\b')" #Because net-tools in debian, ubuntu are obsolete already
SERVER_PORT_V2RAY='443'


sudo apt-get update; apt-get -y upgrade -y;
apt install gnupg gnupg2 gnupg1 dnsutils -y
clear

tput setaf 3 ; tput bold ; echo "" ; echo "AUTO SCRIPT DNSTT Server MultiPort !!! v1.4 by BLRX" ; echo ""
sleep 3
echo "#################################################################"
tput setaf 7 ; tput setab 4 ; tput bold ; printf '\e[104m                   >>>> by BLRX  <<<                             ' ; tput sgr0
echo ""
echo "#################################################################"
sleep 4


# scritp pide de entrada un usuario SSH
echo "[*] DNSTT Server AUTH.."
read -p "NS Domains : " -e -i dns.jaquematedns.xyz DnsNS
clear

echo "[*] Update SERVER.."
sudo apt-get update; apt-get -y upgrade -y;
apt-get update;apt-get -y install wget curl
clear

echo "[*] Install PACKAGE"
sleep 2
sudo apt-get update && upgrade -y;
sudo apt-get install nano -y;
sudo apt-get install g++ -y;
sudo apt-get install git -y;
sudo apt-get install -y iptables -y;
sudo apt-get install net-tools;
apt-get -y install iptables iptables-services;
apt-get install cmake -y;
apt-get install screen wget gcc build-essential g++ make -y;
sudo apt-get install wget -y;
apt-get install nload;
sudo apt-get install iptables-persistent -y;
sudo apt-get --purge remove apache2 -y;
apt-get install software-properties-common -y;
apt install build-essential gcc make -y;
clear


echo "[*] DNSTT"
apt install git -y;
wget -c https://www.dropbox.com/s/vq5k1qixtersd80/dnstt-server?dl=0 -O /usr/local/bin/dnstt-server;
chmod +x /usr/local/bin/dnstt-server
clear


echo 'DNSTT SERVICE'
cat <<EOF > /etc/systemd/system/dnstt-service.service
[Unit]
Description=Daemonize DNSTT Tunnel Server
Wants=network.target
After=network.target
[Service]
ExecStart=/usr/local/bin/dnstt-server -udp :5300 -privkey 926d2e559047d381dfb6f66e020ce5e1f4d9199d3eea71ac9681112b0a2031f6 $DnsNS 127.0.0.1:$SERVER_PORT_V2RAY
Restart=always
RestartSec=3
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl start dnstt-service
systemctl enable --now dnstt-service
clear

echo 'Iptables Services'
cat <<EOF > /etc/systemd/system/hashes-iptables.service
[Unit]
Description=Iptables reboot
Before=network.target
[Service]
Type=oneshot
ExecStart=/usr/sbin/iptables -I INPUT -p udp --dport 5300 -j ACCEPT
ExecStart=/usr/sbin/iptables -t nat -I PREROUTING -i $default_int -p udp --dport 0:65535 -j REDIRECT --to-ports 5300
ExecStart=/usr/sbin/ip6tables -I INPUT -p udp --dport 5300 -j ACCEPT
ExecStart=/usr/sbin/ip6tables -t nat -I PREROUTING -i $default_int -p udp --dport 0:65535 -j REDIRECT --to-ports 5300
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl start hashes-iptables.service
systemctl enable --now hashes-iptables.service
clear