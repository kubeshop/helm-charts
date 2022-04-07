#!/bin/bash
set -e
set -o pipefail

function update_tk_main_chart_version {
    # calculate patch version by incrementing by one:
    tk_version_full=$(grep -iE "^version:" ../charts/testkube/Chart.yaml | awk '{print $NF}')

    # Bumping TestKube version by one:
    tk_version_major=$(echo $tk_version_full | awk -F\. '{print $1}')
    tk_version_minor=$(echo $tk_version_full | awk -F\. '{print $2}')
    tk_version_patch=$(echo $tk_version_full | awk -F\. '{print $3}')

    # Incrementing testKube helm charts patch version by one:
    tk_version_patch=$(expr $tk_version_patch + 1)

    # New TestKube full version:
    tk_version_full_bumped=$tk_version_major.$tk_version_minor.$tk_version_patch
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--helm-chart-folder) target_folder="$2"; shift ;;
        -e|--testkube-executor-name) executor_name="$2"; shift ;;
        -m|--main-chart) main_chart="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Getting testkube-api chart version based on the pushed TAG:
version_full=$(echo $RELEASE_VERSION | sed 's/^v//')
echo "Version recieved: $version_full"

# Getting TestKube main chart version:
if [[ $version_full =~ [0-9].[0-9].0$ ]]
then
    if [[ $main_chart == "true" ]]
    then
        # Just use this tag for main TestKube chart as it's Release:
        tk_version_full_bumped=$version_full
    else
        # Updating TestKube's main chart patch version:
        update_tk_main_chart_version
    fi
else
    # Updating TestKube's main chart patch release version:
    update_tk_main_chart_version
fi

# Checking new TestKube full version:
echo "New main TestKube's chart version is: $tk_version_full_bumped"

if [[ $executor_name == "" ]]
then
    # Lower-casing entered helm-chart-folder name to omit any issues with Upper case latters. 
    target_folder=$(echo "$target_folder" | tr '[:upper:]' '[:lower:]')
    
    # Editing $target_folder Chart, and its App versions:
    sed -i "s/^version: .*$/version: $version_full/" ../charts/$target_folder/Chart.yaml
    sed -i "s/^appVersion: .*$/appVersion: $version_full/" ../charts/$target_folder/Chart.yaml
    echo -e "\nChecking changes made to Chart.yaml of $target_folder\n"
    cat ../charts/$target_folder/Chart.yaml
    
    # Editing Docker tag image for $target_folder:
    sed -i "s/tag:.*$/tag: \"$version_full\"/" ../charts/$target_folder/values.yaml
    echo -e "\nChecking changes made to Docker image:\n"
    grep -i "tag" ../charts/$target_folder/values.yaml
    
    # Editing TestKube's dependency Chart.yaml for $target_folder:
    sed -i "/name: $target_folder/{n;s/^.*version.*/    version: $version_full/}" ../charts/testkube/Chart.yaml
    echo -e "\nChecking if TestKube's Chart.yaml dependencie has been updated:\n"
    grep -iE -A 1 "name: $target_folder" ../charts/testkube/Chart.yaml
fi

# Editing TestKube's main chart version:
sed -i "s/^version:.*/version: $tk_version_full_bumped/" ../charts/testkube/Chart.yaml
echo -e "\nChecking if testkube's main Chart.yaml version has been updated:\n"
grep -iE "^version" ../charts/testkube/Chart.yaml

if [[ $main_chart != "true" ]]
then
    if [[ $executor_name != "" ]]
    then
        # Editing TestKube's executors.yaml if tag was pushed to main chart. E.G. to testKube:
        sed -i "s/\(.*\"image\":.*$executor_name.*\:\).*$/\1$version_full\",/g" ../charts/testkube-api/executors.json
        echo -e "\nChecking if TestKube's executors.json ($executor_name executor) has been updated:\n"
        grep -iE image ../charts/testkube-api/executors.json | grep $executor_name
    fi
else
    # No reason to edit executors.json image tags as it's not a Executors' repo/tag.
    echo "Executors.json is not updated. As this tag was not pushed into Executors' repo."
fi

# Commiting and pushing changes:
git add -A
git commit -m "Tag: $version_full; $target_folder CI/CD. Bumped helm chart, app and docker image tag versions."

# git push origin main
git push --set-upstream https://kubeshop-bot:$GH_PUSH_TOKEN@github.com/kubeshop/helm-charts main