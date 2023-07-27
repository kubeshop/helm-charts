#!/bin/bash
set -e
set -o pipefail

## Update version in Chart.yaml for sub-chart folders (testkube-api, testkube-operator, testkube-dashboard)
# List of folders
folders=("testkube-api" "testkube-operator" "testkube-dashboard" )

function update_sub_chart_version {
    folder_name=$1
    # calculate patch version by incrementing by one:
    tk_version_full=$(grep -iE "^version:" ../charts/$folder_name/Chart.yaml | awk '{print $NF}')

    # Bumping TestKube version by one:
    tk_version_major=$(echo $tk_version_full | awk -F\. '{print $1}')
    tk_version_minor=$(echo $tk_version_full | awk -F\. '{print $2}')
    tk_version_patch=$(echo $tk_version_full | awk -F\. '{print $3}')

    # Incrementing testKube helm charts patch version by one:
    tk_version_patch=$(expr $tk_version_patch + 1)

    # New TestKube full version:
    tk_version_full_bumped=$tk_version_major.$tk_version_minor.$tk_version_patch

    # Update the Chart.yaml file with the new version:
    sed -i "s/^version: $tk_version_full/version: $tk_version_full_bumped/" "../charts/$folder_name/Chart.yaml"
    sed -i "s/^appVersion: $tk_version_full/appVersion: $tk_version_full_bumped/" "../charts/$folder_name/Chart.yaml"
    sed -i "/name: $folder_name/{n;s/^.*version.*/    version: $tk_version_full_bumped/}" "../charts/testkube/Chart.yaml"

    echo "Bumped $folder_name version to $tk_version_full_bumped"
}

# Loop through each folder and update the version
for folder_name in "${folders[@]}"; do
    update_sub_chart_version "$folder_name"
done

## Update version in Chart.yaml for testkube folder
function update_chart_version {
    folder_name=testkube
    # calculate patch version by incrementing by one:
    tk_version_full=$(grep -iE "^version:" ../charts/$folder_name/Chart.yaml | awk '{print $NF}')

    # Bumping TestKube version by one:
    tk_version_major=$(echo $tk_version_full | awk -F\. '{print $1}')
    tk_version_minor=$(echo $tk_version_full | awk -F\. '{print $2}')
    tk_version_patch=$(echo $tk_version_full | awk -F\. '{print $3}')

    # Incrementing testKube helm charts patch version by one:
    tk_version_patch=$(expr $tk_version_patch + 1)

    # New TestKube full version:
    tk_version_full_bumped=$tk_version_major.$tk_version_minor.$tk_version_patch

    # Update the Chart.yaml file with the new version:
    sed -i "s/^version: $tk_version_full/version: $tk_version_full_bumped/" "../charts/$folder_name/Chart.yaml"

    echo "Bumped $folder_name version to $tk_version_full_bumped"
}

update_chart_version

# Commiting and pushing changes:
git add -A
git commit -m "Tag: $tk_version_full_bumped; CI/CD. Bumped main helm chart version."

# git push origin main
git push --set-upstream https://kubeshop-bot:$GH_PUSH_TOKEN@github.com/kubeshop/helm-charts main

# Update Chart.yaml file in develop branch
git fetch origin develop
git checkout develop
git checkout main --  ../charts/testkube/Chart.yaml
git add ../charts/testkube/Chart.yaml
git commit -m "Update Chart.yaml file"
git push --set-upstream https://kubeshop-bot:$GH_PUSH_TOKEN@github.com/kubeshop/helm-charts develop
