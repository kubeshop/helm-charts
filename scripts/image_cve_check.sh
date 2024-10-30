#!/bin/bash

AGENT_IMAGES=images.txt

# Add repos
helm repo add bitnami https://charts.bitnami.com/bitnami

# Build the dependencies
helm dependency build ../charts/testkube

# Get images for the agent chart
helm template test ../charts/testkube --skip-crds --set mongodb.enabled=false --set testkube-api.minio.enabled=false --set testkube-dashboard.enabled=false --set global.testWorkflows.createOfficialTemplates=false | grep "image:" | grep -v "{" | sed 's/"//g' | sed 's/docker.io\///g' | awk '{ print $2 }' | awk 'NF && !seen[$0]++' | sort > "$AGENT_IMAGES"

# Get the images for the workflows
helm template test ../charts/testkube --skip-crds --set mongodb.enabled=false --set testkube-api.minio.enabled=false --set testkube-dashboard.enabled=false --set global.testWorkflows.createOfficialTemplates=false | grep "testkube-tw" | sed 's/"//g' | sed 's/docker.io\///g' | awk '{ print $2 }' | awk 'NF && !seen[$0]++' | sort >> "$AGENT_IMAGES"

# Sort these agent images
sort -o "$AGENT_IMAGES" "$AGENT_IMAGES"

# Check for images that do not start with the image registry
failure=false
while IFS= read -r image; do

    echo "*******************"
    echo "DOCKER SCOUT OUTPUT"
    echo "==================="
    docker scout cves $image --platform linux/amd64 --exit-code --only-severity critical
    ec=$?
    echo "==================="

    if [ $ec -ne 0 ]; then
        echo "Failure: The '$image' has critical CVEs."
        failure=true
    fi
done < "$AGENT_IMAGES"

if [ "$failure" = true ]; then
    echo "Critical CVEs detected."
    exit 1
fi

echo "No critical CVEs detected."
