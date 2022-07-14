#!/bin/bash
set -e

if test "$(whoami)" != "root"
then echo "Sorry, you are not root." && exit 1
fi


# query user for variables
echo -n "Hostname: "
read hostname
echo -n "VPN Username: "
read user
echo -n "Password (must not contain \"): "
read -s pass
echo
echo "You may add more users at a later time by editing ~/vpn/ipsec.secrets"
echo

mkdir -p ~/pki/{cacerts,certs,private}
chmod 700 ~/pki


###########################
##### PREPARE SCRIPTS #####
###########################

echo "Preparing scripts and other files..."

cat > gen_certs.sh <<EOF
#!/bin/bash
ipsec pki --gen --type rsa --size 4096 --outform pem > ~/pki/private/ca-key.pem

ipsec pki --self --ca --lifetime 3650 --in ~/pki/private/ca-key.pem \
    --type rsa --dn "CN=VPN root CA" --outform pem > ~/pki/cacerts/ca-cert.pem

ipsec pki --gen --type rsa --size 4096 --outform pem > ~/pki/private/server-key.pem

ipsec pki --pub --in ~/pki/private/server-key.pem --type rsa \
    | ipsec pki --issue --lifetime 1825 \
        --cacert ~/pki/cacerts/ca-cert.pem \
        --cakey ~/pki/private/ca-key.pem \
        --dn "CN=$hostname" --san "$hostname" \
        --flag serverAuth --flag ikeIntermediate --outform pem \
    >  ~/pki/certs/server-cert.pem


cp -r ~/pki/* /etc/ipsec.d/

EOF
chmod +x gen_certs.sh

cat > reset_iptables.sh <<EOF
#!/bin/bash
if command -v ufw &>/dev/null
then ufw disable &>/dev/null
fi
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
iptables -F
iptables -Z
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p udp --dport  500 -j ACCEPT
iptables -A INPUT -p udp --dport 4500 -j ACCEPT
iptables -A FORWARD --match policy --pol ipsec --dir in  --proto esp -s 10.10.10.0/24 -j ACCEPT
iptables -A FORWARD --match policy --pol ipsec --dir out --proto esp -d 10.10.10.0/24 -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o eth0 -m policy --pol ipsec --dir out -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o eth0 -j MASQUERADE
iptables -t mangle -A FORWARD --match policy --pol ipsec --dir in -s 10.10.10.0/24 -o eth0 -p tcp -m tcp --tcp-flags SYN,RST SYN -m tcpmss --mss 1361:1536 -j TCPMSS --set-mss 1360
EOF
chmod +x reset_iptables.sh

cat > ipsec.conf <<EOF
# ipsec.conf - strongSwan IPsec configuration file
config setup
    charondebug="ike 1, knl 1, cfg 0"
    uniqueids=never

conn ikev2-vpn
    auto=add
    compress=no
    type=tunnel
    keyexchange=ikev2
    fragmentation=yes
    forceencaps=yes
    dpdaction=clear
    dpddelay=300s
    rekey=no
    left=%any
    leftid=$hostname
    leftcert=server-cert.pem
    leftsendcert=always
    leftsubnet=0.0.0.0/0
    right=%any
    rightid=%any
    rightauth=eap-mschapv2
    rightsourceip=10.10.10.0/24
    rightdns=8.8.8.8,8.8.4.4
    rightsendcert=never
    eap_identity=%identity
EOF

cat > ipsec.secrets <<EOF
: RSA "server-key.pem"
$user : EAP "$pass"
EOF

cat > 17-vpn.conf <<EOF
. . .

# Enable forwarding
# Uncomment the following line
net/ipv4/ip_forward=1

. . .

# Do not accept ICMP redirects (prevent MITM attacks)
# Ensure the following line is set
net/ipv4/conf/all/accept_redirects=0

# Do not send ICMP redirects (we are not a router)
# Add the following lines
net/ipv4/conf/all/send_redirects=0
net/ipv4/ip_no_pmtu_disc=1
EOF


################################
##### INSTALL DEPENDENCIES #####
################################

echo "Installing dependencies..."
apt-get update
apt-get install strongswan strongswan-pki


##########################
##### GENERATE CERTS #####
##########################

echo "Generating certificates..."
./gen_certs.sh


###########################
##### CONFIGURE IPSEC #####
###########################

echo "Configuring IPsec..."
mv /etc/ipsec.conf{,.original}

mv ipsec.conf /etc/ipsec.conf
mv ipsec.secrets /etc/ipsec.secrets


echo "Restart Strongswan"
systemctl restart strongswan

# echo "Check Strongswan status"
# systemctl status strongswan

##############################
##### CONFIGURE IPTABLES #####
##############################

echo "Configuring iptables..."
./reset_iptables.sh


############################
##### CONFIGURE KERNEL #####
############################

echo "Configuring kernel networking parameters..."
if [ -d /etc/sysctl.d ]
then
  mv 17-vpn.conf /etc/sysctl.d/17-vpn.conf
  ln -s /etc/sysctl.d/17-vpn.conf 17-vpn.conf
elif [ -f /etc/sysctl.conf ]
then
  cat <(echo ; echo) 17-vpn.conf >> /etc/sysctl.conf
  rm 17-vpn.conf
else
  echo "could not locate sysctl configuration!"
  exit 1
fi
if command -v sysctl &>/dev/null
then sysctl --system &>/dev/null
else "NOTE: reboot may be necessary, could not live-reload kernel params."
fi


# #########################
# ##### RESTART IPSEC #####
# #########################

# echo "Restarting IPsec..."
# set +e
# ipsec restart &>/dev/null
# set -e


####################
##### COMPLETE #####
####################

cat <<EOF
INSTALL COMPLETE.
Please edit and re-execute reset_iptables.sh if appropriate.
Distribute cat /etc/ipsec.d/cacerts/ca-cert.pem to your clients,
ensure they enable trust for IPsec with that certificate.
EOF