#! /bin/bash
instance_id="$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/id)"
zone="$(curl -H "Metadata-Flavor:Google" http://metadata/computeMetadata/v1/instance/zone | cut -d/ -f4)"

curl"gce://$(echo $zone)/$(echo $instance_id)"