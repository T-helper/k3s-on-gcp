#! /bin/bash
INSTANCE_ID="$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/id)"
ZONE="$(curl -H "Metadata-Flavor:Google" http://metadata/computeMetadata/v1/instance/zone | cut -d/ -f4)"

curl -sfL https://get.k3s.io | K3S_TOKEN="${token}" INSTALL_K3S_VERSION="v1.23.8+k3s1" K3S_URL="https://${server_address}:6443" sh -s - \
    --node-label "svccontroller.k3s.cattle.io/enablelb=true"
    --kubelet-arg cloud-provider=external \
    --kubelet-arg provider-id="gce://${project}/$(echo $ZONE)/$(echo $INSTANCE_ID)"