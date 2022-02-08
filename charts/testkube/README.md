# Testkube

This is the Helm chart for [Testkube](https://github.com/kubeshop/testkube) installation.

## Installation

### Dependencies

* Kubernetes cluster administration rights are required.

* We heavily depend on [jetstack cert-manager](https://github.com/jetstack/cert-manager) for webhooks TLS configuration. If it is not installed in your cluster, then please install it with the official instructions [here](https://cert-manager.io/docs/installation/).

### Chart installation

Add repo:

```sh

helm repo add kubeshop https://kubeshop.github.io/helm-charts
helm repo update

```

NOTE: this will add CustomResourceDefinitions and RBAC roles and rolebindings to the cluster.
This install requires having cluster administrative rights.

```sh

helm install testkube kubeshop/testkube --create-namespace --namespace testkube

```

## Deinstallation

NOTE: this will delete CRDs too.

```sh

helm delete testkube -n testkube
kubectl delete namespace testkube

```
