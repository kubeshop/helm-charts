# Kusk Gateway EnvoyFleet

This is the Helm chart for [Kusk Gateway](https://github.com/kubeshop/kusk-gateway) Envoy Fleet installation.

It allows you to submit K8S Custom Resourse that is picked up by Kusk Gateway manager, which setups Envoy Fleet with LoadBalancer Service.

## Installation

Kusk-gateway main [chart](https://github.com/kubeshop/helm-charts/tree/main/charts/kusk-gateway) must be installed first.

After that:

```sh

helm install kusk-gateway-envoyfleet kubeshop/kusk-gateway-envoyfleet --namespace kusk-system

```

You can deploy multiple fleets into any namespace with different names, e.g.

```sh

helm install somename kubeshop/kusk-gateway-envoyfleet --namespace default
helm install someothername kubeshop/kusk-gateway-envoyfleet --namespace default

```

Please keep the names of Helm releases short as Helm prepends the name of the chart to the name of release and Kubernetes resources names created after that will be quite long.
We recommend to use "kusk-gateway-envoyfleet" (chart name) prefix for the release name to keep your Helm releases organized in that namespace (e.g. "helm install kusk-gateway-envoyfleet-somename --namespace default").
Helm will create EnvoyFleet CR as "kusk-gateway-envoyfleet-somename" this way.

If you want to override the name for the resources almost completely, install it as:

```sh

helm install kusk-gateway-envoyfleet-somename kubeshop/kusk-gateway-envoyfleet --namespace default --set fullnameOverride=somename

```

This way EnvoyFleet Custom Resource name will be "somename" and it will be more clear and convenient to put it into API/StaticRoute.

## Deinstallation

```sh

helm delete kusk-gateway-envoyfleet --namespace kusk-system

```
