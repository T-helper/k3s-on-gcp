#! /bin/bash
apt update && apt install wireguard
# curl https://releases.rancher.com/install-docker/19.03.sh | sh

curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.24.4+k3s1" sh -s - \
    --write-kubeconfig-mode 644 \
    --token "${token}" \
    --tls-san "${internal_lb_ip_address}" \
    --tls-san "${external_lb_ip_address}" \
    --node-taint "CriticalAddonsOnly=true:NoExecute" \
    --disable "traefik,local-storage,metrics-server"\
    --datastore-endpoint "postgres://${db_user}:${db_password}@${db_host}:5432/${db_name}" \
    --kube-apiserver-arg "service-node-port-range=80-32767"
    --flannel-backend wireguard
    
    # --docker
    # --kube-apiserver-arg "service-node-port-range=80-32767" \