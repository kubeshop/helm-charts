# Testkube

This is the Helm chart for [Testkube](https://github.com/kubeshop/testkube) installation.

## Installation

### Dependencies

* Kubernetes cluster administration rights are required.

* We heavily depend on [jetstack cert-manager](https://github.com/jetstack/cert-manager) for webhooks TLS configuration. If it is not installed in your cluster, then please install it with the official instructions [here](https://cert-manager.io/docs/installation/)

### Chart installation

Add `kubeshop` Helm repository and update latest charts info:

```sh

helm repo add kubeshop https://kubeshop.github.io/helm-charts
helm repo update
```

NOTE: 
This will add CustomResourceDefinitions and RBAC roles and RoleBindings to the cluster.
This installation requires having cluster administrative rights.

```sh

helm install testkube kubeshop/testkube --create-namespace --namespace testkube
```

## Uninstall

NOTE: Uninstalling Testkube will also delete all CRDs and all resources created by Testkube.

```sh

helm delete testkube -n testkube
kubectl delete namespace testkube

```

## Migration to upgradable CRDs Helm chart
Originally Helm chart stored CRDs in a special crds/ folder. In order to make them upgradable they were moved
into the regular templates/ folder. Unfortunately Helm uses different annotations and labels for resources located
in crds/ and templates/ folders. Please run these commands to fix it:

```sh
kubectl annotate --overwrite crds executors.executor.testkube.io meta.helm.sh/release-name="testkube" meta.helm.sh/release-namespace="testkube"
kubectl annotate --overwrite crds tests.tests.testkube.io meta.helm.sh/release-name="testkube" meta.helm.sh/release-namespace="testkube"
kubectl annotate --overwrite crds scripts.tests.testkube.io meta.helm.sh/release-name="testkube" meta.helm.sh/release-namespace="testkube"
kubectl label --overwrite crds executors.executor.testkube.io app.kubernetes.io/managed-by=Helm
kubectl label --overwrite crds tests.tests.testkube.io app.kubernetes.io/managed-by=Helm
kubectl label --overwrite crds scripts.tests.testkube.io app.kubernetes.io/managed-by=Helm
```
