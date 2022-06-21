# Kusk Gateway

This is the Helm chart for [Kusk Gateway](https://github.com/kubeshop/kusk-gateway) installation.

## Installation

### Dependencies

* Kubernetes cluster administration rights are required.

* If you install the chart to your local machine cluster (k3d or minikube), you may need to install and configure [MetalLB](https://metallb.universe.tf/) to handle LoadBalancer type services,
otherwise EnvoyFleet service ExternlIP address will be in Pending state forever.

### Chart installation

Add repo:

```sh
helm repo add kubeshop https://kubeshop.github.io/helm-charts
helm repo update

```

NOTE: this will add CustomResourceDefinitions and RBAC roles and rolebindings to the cluster.
This install requires having cluster administrative rights.

```sh
helm install kusk-gateway kubeshop/kusk-gateway -n kusk-system --create-namespace
kubectl rollout status -w deployment/kusk-gateway-manager -n kusk-system
```

Then install default EnvoyFleet to the cluster:

```sh
helm install kusk-gateway-envoyfleet kubeshop/kusk-gateway-envoyfleet -n kusk-system
```

## Deinstallation

NOTE: this will delete CRDs too.

```sh
helm delete kusk-gateway-envoyfleet kusk-gateway -n kusk-system
kubectl delete namespace kusk-system
```
