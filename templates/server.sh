#! /bin/bash
instance_id=$(curl http://metadata.google.internal/computeMetadata/v1/instance/id    -H "Metadata-Flavor: Google")

curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.23.8+k3s1" sh -s - \
    --write-kubeconfig-mode 644 \
    --token "${token}" \
    --tls-san "${internal_lb_ip_address}" \
    --tls-san "${external_lb_ip_address}" \
    --node-taint "CriticalAddonsOnly=true:NoExecute" \
    --disable-cloud-controller \
    --disable servicelb \
    --disable traefik \
    --kubelet-arg cloud-provider=external \
    --kubelet-arg provider-id="gce://${project}/${region}/$(hostname)"
    --datastore-endpoint "postgres://${db_user}:${db_password}@${db_host}:5432/${db_name}"