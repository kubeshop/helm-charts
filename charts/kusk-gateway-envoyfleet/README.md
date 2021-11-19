# Kusk Gateway EnvoyFleet

This is the Helm chart for [Kusk Gateway](https://github.com/kubeshop/kusk-gateway) Envoy Fleet installation.

It allows you to submit K8S Custom Resourse that is picked up by Kusk Gateway manager, which setups Envoy Fleet with LoadBalancer Service.

Default values for the chart specify its fleet name ("default") and the size (1 instance).

## Installation

Kusk-gateway main [chart](https://github.com/kubeshop/helm-charts/tree/main/charts/kusk-gateway) must be installed first.

After that:

```sh

helm install kusk-gateway-envoyfleet kubeshop/kusk-gateway-envoyfleet -n kusk-system

```

## Deinstallation

```sh

helm delete kusk-gateway-envoyfleet -n kusk-system

```
