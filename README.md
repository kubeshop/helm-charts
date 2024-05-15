![Kubeshop Projects](https://raw.githubusercontent.com/kubeshop/testkube/main/assets/squishies.png)

<!-- ![Known Vulnerabilities](https://snyk.io/test/github/kubeshop/helm-charts/badge.svg) -->

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
testkube-helm-charts` to see the charts.

## TestKube Helm Charts

The following [TestKube](https://github.com/kubeshop/testkube/) Helm Charts are in this project
 
- `testkube-api`: the TestKube API Server
- `testkube-dashboard`: the TestKube Dashboard for UI interactions with the API Server
- `testkube-operator`: the TestKube Operator
- `testkube`: the main TestKube chart - [Installation Instructions](https://kubeshop.github.io/testkube/installing/#manual-testkube-helm-charts-installation)

> Please note that the testkube Helm chart will install all the needed charts. Including CRDs. It's an umbrella chart.

## Prometheus service monitor 

If have already configured Prometheus stack you can enble service monitor 
for testkube API server to scrape metrics from it. 

you'll need to add `testkube-api.prometheus.enabled=true` value to do this e.g. 

```
helm install testkube kubeshop/testkube --set testkube-api.prometheus.enabled=true
```

## Kusk Gateway Helm Charts

The following [Kusk Gateway](https://github.com/kubeshop/kusk-gateway/) Helm Charts are in this project

- `kusk-gateway`: The main Kusk Gateway chart which installs the CRDs as part of the main install.
- `kusk-gateway-envoyfleet`: The workhorse of Kusk Gateway; Creates a LoadBalancer envoy service which Kusk Gateway's manager component configures to route traffic to your APIs
- `kusk-gateway-api`: Kusk Gateway's API server
- `kusk-gateway-dashboard`: Subchart of Kusk Gateway's API server. Dashboard for UI interactions with the API Server.

## Other projects

If you're interested to see what these Helm Charts install you can use [Monokle](https://github.com/kubeshop/monokle) to 
load and preview all of them:
- clone this repository 
- load the project folder into Monokle
- select and preview each of the Helm charts as described at [Working with Helm](https://kubeshop.github.io/monokle/helm/)

