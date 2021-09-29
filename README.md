![Known Vulnerabilities](https://snyk.io/test/github/kubeshop/helm-charts/badge.svg)

# Kubeshop Helm Charts

This repo contains Helm Charts for Kubeshop projects and makes them available as a 
Helm Repository at https://kubeshop.github.io/helm-charts.

## Helm installation

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

```sh
helm repo add kubeshop https://kubeshop.github.io/helm-charts
```

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
kubtest-helm-charts` to see the charts.

## Kubtest Helm Charts

The following [Kubtest](https://github.com/kubeshop/kubtest/) Helm Charts are in this project
 
- `api-server`: the Kubtest API Server
- `kubtest-dashboard`: the Kubtest Dashboard for UI interactions with API Server
- `kubtest-operator`: the Kubtest Operator
- `postman-executor`: the Postman Executor used for running Postman Collections
- `cypress-executor`: the Cypress Executor used for running Cypress projects (checked out from Git)
- `curl-executor`: the Curl Executor used for running curl command tests.
- `kubtest`: the main Kubtest chart - [Installation Instructions](https://kubeshop.github.io/kubtest/installing/#manual-kubtest-helm-charts-installation)

> Please note that the kubtest Helm chart will install all the needed charts. Including CRDs. It's an umbrella chart.

## Promehteus service monitor 

If have already configured Prometheus stack you can enble service monitor 
for kubtest API server to scrape metrics from it. 

you'll need to add `prometheus.enabled=true` value to do this e.g. 

```
helm install kubtest kubeshop/kubtest --set prometheus.enabled=true
```

## Other projects

If you're interested to see what these Helm Charts install you can use [Monokle](https://github.com/kubeshop/monokle) to 
load and preview all of them:
- clone this repository 
- load the project folder into Monokle
- select and preview each of the Helm charts as described at [Working with Helm](https://kubeshop.github.io/monokle/helm/)

