#! /bin/bash
apt update && apt install wireguard -y && 
curl https://releases.rancher.com/install-docker/19.03.sh | sh

curl -sfL https://get.k3s.io | K3S_TOKEN="${token}" INSTALL_K3S_VERSION="v1.24.4+k3s1" K3S_URL="https://${server_address}:6443" sh -s - \
    --node-label "svccontroller.k3s.cattle.io/enablelb=true" \
    --docker