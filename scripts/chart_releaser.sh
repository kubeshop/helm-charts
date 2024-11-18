#!/bin/bash
set -e
set -o pipefail

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--helm-chart-folder) target_folder="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Getting testkube-api chart version based on the pushed TAG:
VERSION_FULL=$(echo $RELEASE_VERSION | sed 's/^v//')
echo "Version received: $VERSION_FULL"

# Updating TestKube's main chart version:
# Extract the major and minor version numbers from the current version
CURRENT_VERSION=$(grep -iE "^version:" ../charts/testkube/Chart.yaml | awk '{print $NF}')
echo "Current Testkube Chart version is: $CURRENT_VERSION"

CURRENT_MAJOR=$(echo $CURRENT_VERSION | awk -F\. '{print $1}')
CURRENT_MINOR=$(echo $CURRENT_VERSION | awk -F\. '{print $2}')
CURRENT_PATCH=$(echo $CURRENT_VERSION | awk -F\. '{print $3}')

RELEASE_MAJOR=$(echo $VERSION_FULL | awk -F\. '{print $1}')
RELEASE_MINOR=$(echo $VERSION_FULL | awk -F\. '{print $2}')

# Check if the release tag has a higher major and minor version number than the current version
if (( RELEASE_MAJOR > CURRENT_MAJOR )); then
  # If so, increment the major version number and set the new chart version
  NEW_MAJOR=$(expr $CURRENT_MAJOR + 1)
  NEW_MINOR=0
  NEW_PATCH=0
  NEW_VERSION="${NEW_MAJOR}.${NEW_MINOR}.${NEW_PATCH}"
  echo "Current major version incremented to $NEW_MAJOR."
elif (( RELEASE_MAJOR == CURRENT_MAJOR && RELEASE_MINOR > CURRENT_MINOR )); then
  # If the major version number is the same but the minor version number is higher,
  # increment the minor version number and set the new chart version
  NEW_MAJOR=$CURRENT_MAJOR
  NEW_MINOR=$(expr $CURRENT_MINOR + 1)
  NEW_PATCH=0
  NEW_VERSION="${NEW_MAJOR}.${NEW_MINOR}.${NEW_PATCH}"
  echo "Current minor version incremented to $NEW_MINOR."
else
  # If the major and minor version numbers are the same but the patch version number is updated,
  # increment the patch version number and set the new chart version
  NEW_MAJOR=$CURRENT_MAJOR
  NEW_MINOR=$CURRENT_MINOR
  NEW_PATCH=$(expr $CURRENT_PATCH + 1)
  NEW_VERSION="${NEW_MAJOR}.${NEW_MINOR}.${NEW_PATCH}"
  echo "Current patch version incremented to $NEW_PATCH."
fi

# Output the new chart version
echo "New Testkube Chart version is: $NEW_VERSION"

# Editing $target_folder Chart, and its App versions:
sed -i "s/^version: .*$/version: $VERSION_FULL/" ../charts/$target_folder/Chart.yaml
sed -i "s/^appVersion: .*$/appVersion: $VERSION_FULL/" ../charts/$target_folder/Chart.yaml
echo -e "\nChecking changes made to Chart.yaml of $target_folder\n"
cat ../charts/$target_folder/Chart.yaml

# Editing TestKube's dependency Chart.yaml for $target_folder:
sed -i "/name: $target_folder/{n;s/^.*version.*/    version: $VERSION_FULL/}" ../charts/testkube/Chart.yaml
echo -e "\nChecking if TestKube's Chart.yaml dependencies has been updated:\n"
grep -iE -A 1 "name: $target_folder" ../charts/testkube/Chart.yaml

# Editing TestKube's main chart version:
sed -i  "s/^version:.*/version: $NEW_VERSION/" ../charts/testkube/Chart.yaml
echo -e "\nChecking if testkube's main Chart.yaml version has been updated:\n"
grep -iE "^version" ../charts/testkube/Chart.yaml

## Commiting and pushing changes to main
git add -A
git commit -m "Tag: $VERSION_FULL; $target_folder docker image was updated; bumping chart versions."
git push --set-upstream https://kubeshop-bot:$GH_TOKEN@github.com/kubeshop/helm-charts main

