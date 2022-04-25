# Kusk Gateway API

This is the Helm chart for the [Kusk Gateway API](https://github.com/kubeshop/kuskgateway-api-server) installation.

## Installation

### Dependencies

* Kubernetes cluster administration rights are required as RBAC roles and rolebindings are created.

### Chart installation

Add repo:

```sh
helm repo add kubeshop https://kubeshop.github.io/helm-charts
helm repo update

```

We use Kusk Gateway to expose the API server. So install Kusk gateway first

```sh
helm upgrade kusk-gateway kubeshop/kusk-gateway -n kusk-system --create-namespace --install --wait
```

Then install a private EnvoyFleet to the cluster:
```sh
helm upgrade \
	--install \
	--wait \
	--create-namespace \
	--namespace kusk-system \
	--set fullnameOverride=kusk-gateway-private-envoy-fleet \
	--set service.type=ClusterIP \
	kusk-gateway-private-envoy-fleet \
	kubeshop/kusk-gateway-envoyfleet
```

This will create an envoy fleet that is not reachable from outside the cluster until you 
port-forward to it.

Finally, install the API server:
```sh
helm upgrade \
	--install \
	--wait \
	--create-namespace \
	--namespace kusk-system \
	--set fullnameOverride=kusk-gateway-api \
	--set envoyfleet.name=kusk-gateway-private-envoy-fleet \
	--set envoyfleet.namespace=kusk-system \
	kusk-gateway-api \
	kubeshop/kusk-gateway-api
```

## Deinstallation

```sh
helm delete kusk-gateway-api -n kusk-system
helm delete kusk-gateway-private-envoy-fleet -n kusk-system
# NOTE: this will delete CRDs too.
helm delete kusk-gateway -n kusk-system
```
