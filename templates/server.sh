#! /bin/bash
# apt update && apt install wireguard socat -y && 
# curl https://releases.rancher.com/install-docker/19.03.sh | sh

curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL="stable" sh -s - \
    --write-kubeconfig-mode 644 \
    --token "${token}" \
    --tls-san "${internal_lb_ip_address}" \
    --tls-san "${external_lb_ip_address}" \
    --disable "traefik,local-storage" \
    --datastore-endpoint "mysql://${db_user}:${db_password}@tcp(${db_host}:3306)/${db_name}" \




 #   --node-taint "CriticalAddonsOnly=true:NoExecute" \

    #INSTALL_K3S_VERSION="v1.24.4+k3s1" 



    '--flannel-backend' \
        'wireguard' \
        '--kube-apiserver-arg' \
        'service-node-port-range=80-32767' \