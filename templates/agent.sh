#! /bin/bash
curl -sfL https://get.k3s.io | K3S_TOKEN="${token}" INSTALL_K3S_VERSION="v1.24.4+k3s1" K3S_URL="https://${server_address}:6443" sh -s - \
    --node-label "svccontroller.k3s.cattle.io/enablelb=true"