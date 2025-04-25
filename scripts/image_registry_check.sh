#!/bin/bash

REPO=myownrepo.com/prefix
AGENT_IMAGES=images.txt

# Add repos
helm repo add bitnami https://charts.bitnami.com/bitnami

# Build the dependencies
helm dependency build ../charts/testkube

# Get images for the agent chart (testkube chart)
helm template test ../charts/testkube --skip-crds --set global.imageRegistry="$REPO" --set mongodb.enabled=false --set testkube-api.minio.enabled=false --set testkube-dashboard.enabled=false --set global.testWorkflows.createOfficialTemplates=false | grep "image:" | grep -v "{" | sed 's/"//g' | sed 's/docker.io\///g' | awk '{ print $2 }' | awk 'NF && !seen[$0]++' | sort > "$AGENT_IMAGES"

# Get the images for the workflows (testkube chart)
helm template test ../charts/testkube --skip-crds --set global.imageRegistry="$REPO" --set mongodb.enabled=false --set testkube-api.minio.enabled=false --set testkube-dashboard.enabled=false --set global.testWorkflows.createOfficialTemplates=false | grep "testkube-tw" | sed 's/"//g' | sed 's/docker.io\///g' | awk '{ print $2 }' | awk 'NF && !seen[$0]++' | sort >> "$AGENT_IMAGES"

# Get images for the agent chart (testkube-runner chart)
helm template test ../charts/testkube-runner --set global.imageRegistry="$REPO" | grep "image:" | grep -v "{" | sed 's/"//g' | sed 's/docker.io\///g' | awk '{ print $2 }' | awk 'NF && !seen[$0]++' | sort > "$AGENT_IMAGES"

# Get the images for the workflows (testkube-runner chart)
helm template test ../charts/testkube-runner --set global.imageRegistry="$REPO" | grep "testkube-tw" | sed 's/"//g' | sed 's/docker.io\///g' | awk '{ print $2 }' | awk 'NF && !seen[$0]++' | sort >> "$AGENT_IMAGES"

# Sort these agent images
sort -o "$AGENT_IMAGES" "$AGENT_IMAGES"

# Check for images that do not start with the image registry
failure=false
while IFS= read -r line; do
    if [[ ! "$line" =~ ^"$REPO" ]]; then
        echo "Failure: Line '$line' does not start with '$REPO'."
        failure=true
    fi
done < "$AGENT_IMAGES"

if [ "$failure" = true ]; then
    exit 1
fi

echo "All lines start with '$REPO'."
