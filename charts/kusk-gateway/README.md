# Kusk Gateway

This is the Helm chart for [Kusk Gateway](https://github.com/kubeshop/kusk-gateway) installation.

## Installation

Add repo:

```sh
helm repo add kubesop https://kubeshop.github.io/helm-charts
helm repo update

```

NOTE: this will add CustomResourceDefinitions and RBAC roles and rolebindings to the cluster.
This install requires having cluster administrative rights.

```sh
helm install kusk-gateway kubeshop/kusk-gateway -n kusk-system
```

Then install default EnvoyFleet to the cluster:

```sh
helm install kusk-gateway-envoyfleet kubeshop/kusk-gateway-envoyfleet -n kusk-system
```

## Deinstallation

NOTE: this will delete CRDs too.

```sh

helm delete kusk-gateway-envoyfleet kusk-gateway -n kusk-system

```
