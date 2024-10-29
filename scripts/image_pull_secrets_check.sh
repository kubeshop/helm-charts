#!/bin/bash

# Build the dependencies
# TODO
#helm dependency build ../charts/testkube

# Count the number of container segments
COUNT=$(helm template test ../charts/testkube --skip-crds --set mongodb.enabled=false --set testkube-api.minio.enabled=false --set testkube-dashboard.enabled=false --set global.testWorkflows.createOfficialTemplates=false | grep "containers:" | wc -l)

echo "Discovered $COUNT images"

COUNT_IPS1=$(helm template test ../charts/testkube --skip-crds --set mongodb.enabled=false --set testkube-api.minio.enabled=false --set testkube-dashboard.enabled=false --set global.testWorkflows.createOfficialTemplates=false --set global.imagePullSecrets="{ips1-dc41e854-73a2-4560-a549-16b01c69886b,ips2-b0cfb89a-dcad-4001-9466-c2f5ac4a1f18}" | grep ips1-dc41e854-73a2-4560-a549-16b01c69886b | wc -l)
echo "Found $COUNT_IPS1 instances of the first pull secret"

COUNT_IPS2=$(helm template test ../charts/testkube --skip-crds --set mongodb.enabled=false --set testkube-api.minio.enabled=false --set testkube-dashboard.enabled=false --set global.testWorkflows.createOfficialTemplates=false --set global.imagePullSecrets="{ips1-dc41e854-73a2-4560-a549-16b01c69886b,ips2-b0cfb89a-dcad-4001-9466-c2f5ac4a1f18}" | grep ips2-b0cfb89a-dcad-4001-9466-c2f5ac4a1f18 | wc -l)
echo "Found $COUNT_IPS2 instances of the first pull secret"

if [ "$COUNT_IPS1" != "$COUNT" ] | [ "$COUNT_IPS2" != "$COUNT" ]; then
    echo "The number of image pull secrets ($COUNT_IPS1 and $COUNT_IPS2) doest NOT match the number of container segements ($COUNT)."
    exit 1
fi

echo "The number of image pull secrets matches the number of container segments."
