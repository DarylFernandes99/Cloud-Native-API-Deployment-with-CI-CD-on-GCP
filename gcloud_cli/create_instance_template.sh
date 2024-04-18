#!/bin/bash

project_id=$1
region=$2
instance_name="${3}-$(date +"%d%m%y%H%M%S")"
machine_type=$4
disk_size=$5
subnet=$6
service_account=$7
scopes=$8
tags=$9
labels=${10}
instance_group_name=${11}
key_ring_name=${12}
crypto_key_name=${13}
PACKER_IMAGE_NAME=${14}
startup_script="${15}"

gcloud compute instance-templates create $instance_name \
    --project=$project_id \
    --machine-type=$machine_type \
    --network-interface=network-tier=PREMIUM,subnet=$subnet \
    --instance-template-region=$region \
    --metadata=startup-script="$startup_script" \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account=$service_account \
    --scopes=$scopes \
    --region=$region \
    --tags=$tags \
    --create-disk=auto-delete=yes,boot=yes,device-name=$instance_name,image=projects/$project_id/global/images/$PACKER_IMAGE_NAME,kms-key=projects/$project_id/locations/$region/keyRings/$key_ring_name/cryptoKeys/$crypto_key_name,mode=rw,size=$disk_size,type=pd-balanced \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=$labels \
    --reservation-affinity=any \

if [[ $? -eq 0 ]]; then
    echo "Created instance template - $instance_name"
    gcloud compute instance-groups managed rolling-action start-update $instance_group_name \
        --version="template=projects/$project_id/regions/$region/instanceTemplates/$instance_name" \
        --region=$region \
        --max-unavailable=0
    if [[ $? -eq 0 ]]; then
        echo "Updated instance template in $instance_group_name"
        gcloud compute instance-groups managed wait-until $instance_group_name \
            --version-target-reached \
            --region=$region
    else
        echo "Failed to update instance template in $instance_group_name"
    fi
else
    echo "Failed to create instance template - $instance_name"
fi


# gcloud compute instance-groups managed set-instance-template $instance_group_name \
#     --template=$instance_name
# gcloud compute instance-groups managed rolling-action replace $instance_group_name \
#     --max-surge 1 \
#     --max-unavailable 0
