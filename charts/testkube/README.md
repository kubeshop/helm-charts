# testkube

Testkube is an open-source platform that simplifies the deployment and management of automated testing infrastructure.

![Version: 1.16.7](https://img.shields.io/badge/Version-1.16.7-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

## Install

Add `kubeshop` Helm repository and fetch latest charts info:

```sh
helm repo add kubeshop https://kubeshop.github.io/helm-charts
helm repo update
```

### TLS

Testkube API needs to have additional configuration if NATS or MinIO (or any S3-compatible storage) is used.
THe following sections describe how to configure TLS for NATS and MinIO.

#### NATS

If you want to provision NATS server with TLS, first you will need to create a Kubernetes secret which contains the
server certificate, certificate key and CA certificate, and then you can use the following configuration

```yaml
nats:
  nats:
    tls:
      allowNonTLS: false
      secret:
        name: nats-server-cert
      ca: "ca.crt"
      cert: "cert.crt"
      key: "cert.key"
```

If NATS is configured to use TLS, Testkube API needs to set the `secure` flag so it uses a secure protocol when connecting to NATS.

```yaml
testkube-api:
  nats:
    tls:
      enabled: true
```

Additionally, if NATS is configured to use a self-signed certificate, Testkube API needs to have the CA & client certificate in order to verify the NATS server certificate.
You will need to create a Kubernetes secret which contains the client certificate, certificate key and CA certificate.

```yaml
testkube-api:
  nats:
    tls:
      enabled: true
      mountCACertificate: true
      certSecret:
        enabled: true
```

It is also possible to skip the verification of the NATS server certificate by setting the `skipVerify` flag to `true`.

```yaml
testkube-api:
  nats:
    tls:
      enabled: true
      skipVerify: true
```

#### MinIO/S3

Currently, Testkube doesn't support provisioning MinIO with TLS. However, if you use an external MinIO (or any S3-compatible storage)
you can configure Testkube API to use TLS when connecting to it.

```yaml
testkube-api:
  storage:
    SSL: true
```

Additionally, if S3 server is configured to use a self-signed certificate, Testkube API needs to have the CA & client certificate in order to verify the S3 server certificate.
You will need to create a Kubernetes secret which contains the client certificate, certificate key and CA certificate.

```yaml
testkube-api:
  storage:
    SSL: true
    mountCACertificate: true
    certSecret:
      enabled: true
```

It is also possible to skip the verification of the S3 server certificate by setting the `skipVerify` flag to `true`.

```yaml
testkube-api:
  storage:
    SSL: true
    skipVerify: true
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

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../global | global | 0.1.2 |
| file://../testkube-api | testkube-api | 1.16.8 |
| file://../testkube-dashboard | testkube-dashboard | 1.15.0 |
| file://../testkube-operator | testkube-operator | 1.16.0 |
| https://charts.bitnami.com/bitnami | mongodb | 13.10.1 |
| https://nats-io.github.io/k8s/helm/charts/ | nats | 0.19.1 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global | object | `{"annotations":{},"imagePullSecrets":[],"imageRegistry":"","labels":{}}` | Important! Please, note that this will override sub-chart image parameters. |
| global.annotations | object | `{}` | Annotations to add to all deployed objects |
| global.imagePullSecrets | list | `[]` | Global Docker registry secret names as an array |
| global.imageRegistry | string | `""` | Global Docker image registry |
| global.labels | object | `{}` | Labels to add to all deployed objects |
| mongodb.auth.enabled | bool | `false` | Toggle whether to enable MongoDB authentication |
| mongodb.containerSecurityContext | object | `{}` | Security Context for MongoDB container |
| mongodb.enabled | bool | `true` | Toggle whether to install MongoDB |
| mongodb.fullnameOverride | string | `"testkube-mongodb"` | MongoDB fullname override |
| mongodb.image.pullSecrets | list | `[]` | MongoDB image pull Secret |
| mongodb.image.registry | string | `"docker.io"` | MongoDB image registry |
| mongodb.image.repository | string | `"zcube/bitnami-compat-mongodb"` | MongoDB image repository |
| mongodb.image.tag | string | `"6.0.5-debian-11-r64"` | MongoDB image tag |
| mongodb.podSecurityContext | object | `{}` | MongoDB Pod Security Context |
| mongodb.resources | object | `{"requests":{"cpu":"150m","memory":"100Mi"}}` | MongoDB resource settings |
| mongodb.service | object | `{"clusterIP":"","nodePort":true,"port":"27017","portName":"mongodb"}` | MongoDB service settings |
| mongodb.tolerations | list | `[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]` | Tolerations to schedule a workload to nodes with any architecture type. Required for deployment to GKE cluster. |
| nats.exporter.resources | object | `{}` | Exporter resources settings |
| nats.exporter.securityContext | object | `{}` | Security Context for Exporter container |
| nats.imagePullSecrets | list | `[]` |  |
| nats.nats.limits.maxPayload | string | `"8MB"` | Max payload |
| nats.nats.resources | object | `{}` | NATS resource settings |
| nats.nats.securityContext | object | `{}` | Security Context for NATS container |
| nats.natsbox.securityContext | object | `{}` | Security Context for NATS Box container |
| nats.natsbox.tolerations | list | `[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]` | NATS Box tolerations settings |
| nats.reloader.securityContext | object | `{}` | Security Context for Reloader container |
| nats.securityContext | object | `{}` | NATS Pod Security Context |
| nats.tolerations[0].effect | string | `"NoSchedule"` |  |
| nats.tolerations[0].key | string | `"kubernetes.io/arch"` |  |
| nats.tolerations[0].operator | string | `"Equal"` |  |
| nats.tolerations[0].value | string | `"arm64"` |  |
| preUpgradeHook | object | `{"annotations":{},"enabled":true,"image":{"pullPolicy":"IfNotPresent","pullSecrets":[],"registry":"docker.io","repository":"bitnami/kubectl","tag":"1.28.2"},"labels":{},"name":"mongodb-upgrade","nodeSelector":{},"podAnnotations":{},"podSecurityContext":{},"resources":{},"securityContext":{},"serviceAccount":{"create":true},"tolerations":[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}],"ttlSecondsAfterFinished":100}` | MongoDB pre-upgrade parameters |
| preUpgradeHook.enabled | bool | `true` | Upgrade hook is enabled |
| preUpgradeHook.image | object | `{"pullPolicy":"IfNotPresent","pullSecrets":[],"registry":"docker.io","repository":"bitnami/kubectl","tag":"1.28.2"}` | Specify image |
| preUpgradeHook.name | string | `"mongodb-upgrade"` | Upgrade hook name |
| preUpgradeHook.nodeSelector | object | `{}` | Node labels for pod assignment. |
| preUpgradeHook.podSecurityContext | object | `{}` | MongoDB Upgrade Pod Security Context |
| preUpgradeHook.resources | object | `{}` | Specify resource limits and requests |
| preUpgradeHook.securityContext | object | `{}` | Security Context for MongoDB Upgrade kubectl container |
| preUpgradeHook.serviceAccount | object | `{"create":true}` | Create SA for upgrade hook |
| preUpgradeHook.tolerations | list | `[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]` | Tolerations to schedule a workload to nodes with any architecture type. Required for deployment to GKE cluster. |
| testkube-api.additionalNamespaces | list | `[]` | Watch namespaces. In this case, a Role and a RoleBinding will be created for each specified namespace. |
| testkube-api.additionalVolumeMounts | list | `[]` | Additional volume mounts to be added |
| testkube-api.additionalVolumes | list | `[]` | Additional volumes to be added |
| testkube-api.analyticsEnabled | bool | `true` | Enable analytics for Testkube |
| testkube-api.cdeventsTarget | string | `""` |  |
| testkube-api.cliIngress.annotations | object | `{}` | Additional annotations for the Ingress resource. |
| testkube-api.cliIngress.enabled | bool | `false` | Use ingress |
| testkube-api.cliIngress.hosts | list | `["testkube.example.com"]` | Hostnames must be provided if Ingress is enabled. |
| testkube-api.cliIngress.oauth.clientID | string | `""` | OAuth Client ID |
| testkube-api.cliIngress.oauth.clientSecret | string | `""` | OAuth Client Secret |
| testkube-api.cliIngress.oauth.provider | string | `"github"` | OAuth Provider |
| testkube-api.cliIngress.oauth.scopes | string | `""` | OAuth Scopes |
| testkube-api.cliIngress.path | string | `"/results/(v\\d/.*)"` |  |
| testkube-api.cliIngress.tls | list | `[]` | Placing a host in the TLS config will indicate a certificate should be created |
| testkube-api.cliIngress.tlsenabled | bool | `false` | Toggle whether to enable TLS on the ingress |
| testkube-api.cloud.key | string | `""` | Testkube Clouc License Key (for Environment) |
| testkube-api.cloud.url | string | `"agent.testkube.io:443"` | Testkube Cloud API URL |
| testkube-api.cloud.uiUrl | string | `""` | Testkube Cloud UI URL |
| testkube-api.clusterName | string | `""` |  |
| testkube-api.dashboardUri | string | `""` |  |
| testkube-api.enableSecretsEndpoint | bool | `false` |  |
| testkube-api.executors | string | `""` | default executors as base64-encoded string |
| testkube-api.extraEnvVars | list | `[]` | Extra environment variables to be set on deployment |
| testkube-api.fullnameOverride | string | `"testkube-api-server"` | Testkube API full name override |
| testkube-api.image.digest | string | `""` | Testkube API image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag |
| testkube-api.image.pullPolicy | string | `"IfNotPresent"` | Testkube API image tag |
| testkube-api.image.pullSecrets | list | `[]` | Testkube API k8s secret for private registries |
| testkube-api.image.registry | string | `"docker.io"` | Testkube API image registry |
| testkube-api.image.repository | string | `"kubeshop/testkube-api-server"` | Testkube API image name |
| testkube-api.jobServiceAccountName | string | `""` | SA that is used by a job. Can be annotated with the IAM Role Arn to access S3 service in AWS Cloud. |
| testkube-api.livenessProbe | object | `{"initialDelaySeconds":15}` | Testkube API Liveness probe parameters |
| testkube-api.livenessProbe.initialDelaySeconds | int | `15` | Initial delay for liveness probe |
| testkube-api.logs.bucket | string | `"testkube-logs"` | Bucket should be specified if storage is "minio" |
| testkube-api.logs.storage | string | `"minio"` | Log storage can either be "minio" or "mongo" |
| testkube-api.minio.accessModes | list | `["ReadWriteOnce"]` | PVC Access Modes for Minio. The volume is mounted as read-write by a single node. |
| testkube-api.minio.affinity | object | `{}` | Affinity for pod assignment. |
| testkube-api.minio.enabled | bool | `true` | Toggle whether to install MinIO |
| testkube-api.minio.extraEnvVars | object | `{}` | Minio extra vars |
| testkube-api.minio.extraVolumeMounts | list | `[]` |  |
| testkube-api.minio.extraVolumes | list | `[]` |  |
| testkube-api.minio.image | object | `{"pullSecrets":[],"registry":"docker.io","repository":"minio/minio","tag":"RELEASE.2023-09-16T01-01-47Z"}` | Minio image from DockerHub |
| testkube-api.minio.minioRootPassword | string | `"minio123"` | Root password |
| testkube-api.minio.minioRootUser | string | `"minio"` | Root username |
| testkube-api.minio.nodeSelector | object | `{}` | Node labels for pod assignment. |
| testkube-api.minio.podSecurityContext | object | `{}` | MinIO Pod Security Context |
| testkube-api.minio.priorityClassName | string | `""` |  |
| testkube-api.minio.resources | object | `{}` | MinIO Resources settings |
| testkube-api.minio.secretPasswordKey | string | `""` |  |
| testkube-api.minio.secretPasswordName | string | `""` |  |
| testkube-api.minio.secretUserKey | string | `""` |  |
| testkube-api.minio.secretUserName | string | `""` |  |
| testkube-api.minio.securityContext | object | `{}` | Security Context for MinIO container |
| testkube-api.minio.serviceAccountName | string | `""` | ServiceAccount name to use for Minio |
| testkube-api.minio.storage | string | `"10Gi"` | PVC Storage Request for MinIO. Should be available in the cluster. |
| testkube-api.minio.tolerations | list | `[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]` | Tolerations to schedule a workload to nodes with any architecture type. Required for deployment to GKE cluster. |
| testkube-api.mongodb.allowDiskUse | bool | `true` | Allow or prohibit writing temporary files on disk when a pipeline stage exceeds the 100 megabyte limit. |
| testkube-api.mongodb.dsn | string | `"mongodb://testkube-mongodb:27017"` | MongoDB DSN |
| testkube-api.multinamespace.enabled | bool | `false` |  |
| testkube-api.nameOverride | string | `"api-server"` | Testkube API name override |
| testkube-api.nats.enabled | bool | `true` | Use NATS |
| testkube-api.nats.tls.certSecret.baseMountPath | string | `"/etc/client-certs/storage"` | Base path to mount the client certificate secret |
| testkube-api.nats.tls.certSecret.caFile | string | `"ca.crt"` | Path to ca file (used for self-signed certificates) |
| testkube-api.nats.tls.certSecret.certFile | string | `"cert.crt"` | Path to client certificate file |
| testkube-api.nats.tls.certSecret.enabled | bool | `false` | Toggle whether to mount k8s secret which contains storage client certificate (cert.crt, cert.key, ca.crt) |
| testkube-api.nats.tls.certSecret.keyFile | string | `"cert.key"` | Path to client certificate key file |
| testkube-api.nats.tls.certSecret.name | string | `"nats-client-cert"` | Name of the storage client certificate secret |
| testkube-api.nats.tls.enabled | bool | `false` | Toggle whether to enable TLS in NATS client |
| testkube-api.nats.tls.mountCACertificate | bool | `false` | If enabled, will also require a CA certificate to be provided |
| testkube-api.nats.tls.skipVerify | bool | `false` | Toggle whether to verify certificates |
| testkube-api.nats.uri | string | `"nats://testkube-nats:4222"` | NATS URI |
| testkube-api.podSecurityContext | object | `{}` | Testkube API Pod Security Context |
| testkube-api.podStartTimeout | string | `"30m"` | Testkube timeout for pod start |
| testkube-api.priorityClassName | string | `""` |  |
| testkube-api.prometheus.enabled | bool | `false` | Use monitoring |
| testkube-api.prometheus.interval | string | `"15s"` | Scrape interval |
| testkube-api.prometheus.monitoringLabels | object | `{}` | The name of the label to use in serviceMonitor if Prometheus is enabled |
| testkube-api.rbac | object | `{"create":true}` | Toggle whether to deploy Testkube API RBAC |
| testkube-api.readinessProbe | object | `{"initialDelaySeconds":30}` | Testkube API Readiness probe parameters |
| testkube-api.readinessProbe.initialDelaySeconds | int | `30` | Initial delay for readiness probe |
| testkube-api.resources | object | `{"requests":{"cpu":"200m","memory":"200Mi"}}` | Testkube API resource requests and limits |
| testkube-api.securityContext | object | `{}` | Security Context for testkube-api container |
| testkube-api.service.annotations | object | `{}` | Service Annotations |
| testkube-api.service.labels | object | `{}` | Service labels |
| testkube-api.service.port | int | `8088` | HTTP Port |
| testkube-api.service.type | string | `"ClusterIP"` | Adapter service type |
| testkube-api.serviceAccount.annotations | object | `{}` |  |
| testkube-api.serviceAccount.create | bool | `true` |  |
| testkube-api.serviceAccount.name | string | `""` |  |
| testkube-api.slackConfig | string | `nil` | Slack config for the events, tests, testsuites and channels |
| testkube-api.slackSecret | string | `""` | Slack secret to store slackToken, the key name should be SLACK_TOKEN |
| testkube-api.slackToken | string | `""` | Slack token from the testkube authentication endpoint |
| testkube-api.storage.SSL | bool | `false` | MinIO Use SSL |
| testkube-api.storage.accessKey | string | `"minio123"` | MinIO Secret Access Key |
| testkube-api.storage.accessKeyId | string | `"minio"` | MinIO Access Key ID |
| testkube-api.storage.bucket | string | `"testkube-artifacts"` | MinIO Bucket |
| testkube-api.storage.certSecret.baseMountPath | string | `"/etc/client-certs/storage"` | Base path to mount the client certificate secret |
| testkube-api.storage.certSecret.caFile | string | `"ca.crt"` | Path to ca file (used for self-signed certificates) |
| testkube-api.storage.certSecret.certFile | string | `"cert.crt"` | Path to client certificate file |
| testkube-api.storage.certSecret.enabled | bool | `false` | Toggle whether to mount k8s secret which contains storage client certificate (cert.crt, cert.key, ca.crt) |
| testkube-api.storage.certSecret.keyFile | string | `"cert.key"` | Path to client certificate key file |
| testkube-api.storage.certSecret.name | string | `"storage-client-cert"` | Name of the storage client certificate secret |
| testkube-api.storage.compressArtifacts | bool | `true` | Toggle whether to compress artifacts in Testkube API |
| testkube-api.storage.endpoint | string | `""` | MinIO endpoint |
| testkube-api.storage.endpoint_port | string | `"9000"` | MinIO endpoint port |
| testkube-api.storage.expiration | int | `0` | MinIO Expiration period in days |
| testkube-api.storage.mountCACertificate | bool | `false` | If enabled, will also require a CA certificate to be provided |
| testkube-api.storage.region | string | `""` | MinIO Region |
| testkube-api.storage.scrapperEnabled | bool | `true` | Toggle whether to enable scraper in Testkube API |
| testkube-api.storage.secretKeyAccessKeyId | string | `""` | Key for storage accessKeyId taken from k8s secret |
| testkube-api.storage.secretKeySecretAccessKey | string | `""` | Key for storage secretAccessKeyId taken from k8s secret |
| testkube-api.storage.secretNameAccessKeyId | string | `""` | k8s Secret name for storage accessKeyId |
| testkube-api.storage.secretNameSecretAccessKey | string | `""` | K8s Secret Name for storage secretAccessKeyId |
| testkube-api.storage.skipVerify | bool | `false` | Toggle whether to verify TLS certificates |
| testkube-api.storage.token | string | `""` | MinIO Token |
| testkube-api.testConnection.enabled | bool | `true` | Toggle whether to create Test Connection pod |
| testkube-api.testConnection.resources | object | `{}` | Test Connection resource settings |
| testkube-api.testConnection.tolerations | list | `[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]` | Tolerations to schedule a workload to nodes with any architecture type. Required for deployment to GKE cluster. |
| testkube-api.testServiceAccount | object | `{"annotations":{},"create":true}` | Service Account parameters |
| testkube-api.testServiceAccount.annotations | object | `{}` | Annotations to add to the service account |
| testkube-api.testServiceAccount.create | bool | `true` | Specifies whether a service account should be created |
| testkube-api.tolerations | list | `[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]` | Tolerations to schedule a workload to nodes with any architecture type. Required for deployment to GKE cluster. |
| testkube-api.uiIngress.annotations | object | `{}` | Additional annotations for the Ingress resource. |
| testkube-api.uiIngress.enabled | bool | `false` | Use Ingress |
| testkube-api.uiIngress.hosts | list | `["testkube.example.com"]` | Hostnames must be provided if Ingress is enabled. |
| testkube-api.uiIngress.path | string | `"/results/(v\\d/.*)"` |  |
| testkube-api.uiIngress.tls | list | `[]` | Placing a host in the TLS config will indicate a certificate should be created |
| testkube-api.uiIngress.tlsenabled | bool | `false` |  |
| testkube-dashboard | object | `{"affinity":{},"apiServerEndpoint":"","autoscaling":{"annotations":{},"enabled":false,"labels":{},"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80,"targetMemoryUtilizationPercentage":80},"disableTelemetry":false,"enabled":true,"extraEnvVars":[],"fullnameOverride":"testkube-dashboard","image":{"digest":"","pullPolicy":"IfNotPresent","pullSecrets":[],"registry":"docker.io","repository":"kubeshop/testkube-dashboard"},"ingress":{"annotations":{},"enabled":false,"hosts":[],"ipv6enabled":false,"labels":{},"path":"/","tls":[],"tlsenabled":false},"nameOverride":"dashboard","nodeSelector":{},"oauth2":{"annotations":{},"args":[],"enabled":false,"env":{"clientId":"","clientSecret":"","cookieSecret":"","cookieSecure":"false","githubOrg":"","redirectUrl":"http://testkube.example.com/oauth2/callback","secretClientIdKey":"","secretClientIdName":"","secretClientSecretKey":"","secretClientSecretName":"","secretCookieSecretKey":"","secretCookieSecretName":"","secretGithubOrgKey":"","secretGithubOrgName":""},"extraEnvFrom":[],"extraEnvVars":[],"image":{"pullPolicy":"Always","pullSecrets":[],"registry":"quay.io","repository":"oauth2-proxy/oauth2-proxy","tag":"latest"},"ingress":{"annotations":{},"labels":{}},"labels":{},"name":"oauth2-proxy","path":"/oauth2","podAnnotations":{},"podLabels":{},"port":4180,"priorityClassName":"","serviceAnnotations":{},"serviceLabels":{},"serviceType":"ClusterIP","volumeMounts":[],"volumes":[]},"podAnnotations":{},"podLabels":{},"podSecurityContext":{},"priorityClassName":"","proxyPrefix":"","replicaCount":1,"resources":{},"securityContext":{},"service":{"annotations":{},"port":8080,"type":"ClusterIP"},"serviceAccount":{"annotations":{},"create":true,"name":""},"testConnection":{"enabled":true,"resources":{},"tolerations":[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]},"tolerations":[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]}` | Testkube Dashboard parameters |
| testkube-dashboard.affinity | object | `{}` | Note: podAffinityPreset, podAntiAffinityPreset, and nodeAffinityPreset will be ignored when it's set |
| testkube-dashboard.apiServerEndpoint | string | `""` | Testkube API Server endpoint |
| testkube-dashboard.autoscaling.annotations | object | `{}` | Specific autoscaling annotations |
| testkube-dashboard.autoscaling.enabled | bool | `false` | Enable autoscaling for Testkube dashboard deployment |
| testkube-dashboard.autoscaling.labels | object | `{}` | Specific autoscaling labels |
| testkube-dashboard.autoscaling.maxReplicas | int | `100` | Maximum number of replicas to scale out |
| testkube-dashboard.autoscaling.minReplicas | int | `1` | Minimum number of replicas to scale back |
| testkube-dashboard.autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU utilization percentage |
| testkube-dashboard.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Target Memory utilization percentage |
| testkube-dashboard.disableTelemetry | bool | `false` | Force disabling telemetry on the UI |
| testkube-dashboard.enabled | bool | `true` | Deploy dashboard |
| testkube-dashboard.extraEnvVars | list | `[]` | Extra environment variables to be set on deployment |
| testkube-dashboard.fullnameOverride | string | `"testkube-dashboard"` | Testkube Dashboard fullname override |
| testkube-dashboard.image.digest | string | `""` | Dashboard Image digest. If set, will override the tag |
| testkube-dashboard.image.pullPolicy | string | `"IfNotPresent"` | Dashboard image tag |
| testkube-dashboard.image.pullSecrets | list | `[]` | Dashboard k8s secret for private registries |
| testkube-dashboard.image.registry | string | `"docker.io"` | Dashboard image registry. Can be overridden by global parameters |
| testkube-dashboard.image.repository | string | `"kubeshop/testkube-dashboard"` | Dashboard image name |
| testkube-dashboard.ingress | object | `{"annotations":{},"enabled":false,"hosts":[],"ipv6enabled":false,"labels":{},"path":"/","tls":[],"tlsenabled":false}` | Ingress parameters |
| testkube-dashboard.ingress.annotations | object | `{}` | Additional annotations for the Ingress resource. |
| testkube-dashboard.ingress.enabled | bool | `false` | Use ingress |
| testkube-dashboard.ingress.hosts | list | `[]` | Hostnames must be provided if Ingress is enabled. |
| testkube-dashboard.ingress.labels | object | `{}` | Specific Ingress labels |
| testkube-dashboard.ingress.path | string | `"/"` | Path to controller |
| testkube-dashboard.ingress.tls | list | `[]` | Placing a host in the TLS config will indicate a certificate should be created |
| testkube-dashboard.nameOverride | string | `"dashboard"` | Testkube Dashboard name override |
| testkube-dashboard.nodeSelector | object | `{}` | Node labels for pod assignment. |
| testkube-dashboard.oauth2.annotations | object | `{}` | Oauth2 specific annotations |
| testkube-dashboard.oauth2.args | list | `[]` | Array of args for oauth2 provider or github as default |
| testkube-dashboard.oauth2.enabled | bool | `false` | Use oauth |
| testkube-dashboard.oauth2.env | object | `{"clientId":"","clientSecret":"","cookieSecret":"","cookieSecure":"false","githubOrg":"","redirectUrl":"http://testkube.example.com/oauth2/callback","secretClientIdKey":"","secretClientIdName":"","secretClientSecretKey":"","secretClientSecretName":"","secretCookieSecretKey":"","secretCookieSecretName":"","secretGithubOrgKey":"","secretGithubOrgName":""}` | Pod environment variables for Teskube UI authentication |
| testkube-dashboard.oauth2.env.clientId | string | `""` | Client ID from Github OAuth application |
| testkube-dashboard.oauth2.env.clientSecret | string | `""` | Client Secret from Github OAuth application |
| testkube-dashboard.oauth2.env.cookieSecret | string | `""` | cookie secret generated using OpenSSL |
| testkube-dashboard.oauth2.env.cookieSecure | string | `"false"` | false for http connection, true for https connections |
| testkube-dashboard.oauth2.env.githubOrg | string | `""` | if you need to provide access only to members of your organization |
| testkube-dashboard.oauth2.env.redirectUrl | string | `"http://testkube.example.com/oauth2/callback"` | "http://demo.testkube.io/oauth2/callback" |
| testkube-dashboard.oauth2.env.secretClientIdKey | string | `""` | k8s Secret Name key for clientId |
| testkube-dashboard.oauth2.env.secretClientIdName | string | `""` | k8s Secret Name for clientId |
| testkube-dashboard.oauth2.env.secretClientSecretKey | string | `""` | k8s Secret Key for clientSecret |
| testkube-dashboard.oauth2.env.secretClientSecretName | string | `""` | k8s Secret Name for clientSecret |
| testkube-dashboard.oauth2.env.secretCookieSecretKey | string | `""` | k8s Secret Key for CookieSecret |
| testkube-dashboard.oauth2.env.secretCookieSecretName | string | `""` | k8s Secret Name for CookieSecret |
| testkube-dashboard.oauth2.env.secretGithubOrgKey | string | `""` | k8s Secret Key for GithubOrg |
| testkube-dashboard.oauth2.env.secretGithubOrgName | string | `""` | k8s Secret Name for GithubOrg |
| testkube-dashboard.oauth2.extraEnvFrom | list | `[]` | Array with extra sources for environment variables |
| testkube-dashboard.oauth2.extraEnvVars | list | `[]` | Array with extra environment variables to add to Locator nodes |
| testkube-dashboard.oauth2.image.pullPolicy | string | `"Always"` | Oauth Image pull policy |
| testkube-dashboard.oauth2.image.pullSecrets | list | `[]` | Oauth k8s secret for private registries |
| testkube-dashboard.oauth2.image.registry | string | `"quay.io"` | Oauth image registry. Can be overridden by global parameters |
| testkube-dashboard.oauth2.image.repository | string | `"oauth2-proxy/oauth2-proxy"` | Oauth image name |
| testkube-dashboard.oauth2.image.tag | string | `"latest"` | Oauth image tag |
| testkube-dashboard.oauth2.ingress | object | `{"annotations":{},"labels":{}}` | Add additional Ingress labels |
| testkube-dashboard.oauth2.ingress.annotations | object | `{}` | add Ingress annotations |
| testkube-dashboard.oauth2.labels | object | `{}` | Oauth2 specific labels |
| testkube-dashboard.oauth2.name | string | `"oauth2-proxy"` | Oauth Deployment name |
| testkube-dashboard.oauth2.path | string | `"/oauth2"` | Ingress path |
| testkube-dashboard.oauth2.podAnnotations | object | `{}` | Oauth2 pod annotations |
| testkube-dashboard.oauth2.podLabels | object | `{}` | Add additional labels to the pod (evaluated as a template) |
| testkube-dashboard.oauth2.port | int | `4180` | Oauth container port |
| testkube-dashboard.oauth2.serviceAnnotations | object | `{}` | Oauth2 Service annotations |
| testkube-dashboard.oauth2.serviceLabels | object | `{}` | Add additional service labels |
| testkube-dashboard.oauth2.serviceType | string | `"ClusterIP"` | Oauth2 Service type |
| testkube-dashboard.podAnnotations | object | `{}` | Testkube Dashboard Pod annotations |
| testkube-dashboard.podLabels | object | `{}` | Extra labels for Testkube Dashboard pods |
| testkube-dashboard.podSecurityContext | object | `{}` | Testkube Dashboard Pod Security Context |
| testkube-dashboard.replicaCount | int | `1` | Number of Testkube Dashboard Pod replicas |
| testkube-dashboard.resources | object | `{}` | Testkube Dashboard resource settings |
| testkube-dashboard.securityContext | object | `{}` | Security Context for testkube-dashboard container |
| testkube-dashboard.service.annotations | object | `{}` | Additional custom annotations for the service |
| testkube-dashboard.service.port | int | `8080` | Dashboard port |
| testkube-dashboard.service.type | string | `"ClusterIP"` | Adapter service type |
| testkube-dashboard.serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | Service Account parameters |
| testkube-dashboard.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| testkube-dashboard.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| testkube-dashboard.serviceAccount.name | string | `""` | If not set and create is true, a name is generated using the fullname template |
| testkube-dashboard.testConnection | object | `{"enabled":true,"resources":{},"tolerations":[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]}` | Test Connection pod |
| testkube-dashboard.testConnection.tolerations | list | `[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]` | Tolerations to schedule a workload to nodes with any architecture type. Required for deployment to GKE cluster. |
| testkube-dashboard.tolerations | list | `[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]` | Tolerations to schedule a workload to nodes with any architecture type. Required for deployment to GKE cluster. |
| testkube-operator.affinity | object | `{}` | Affinity for Testkube Operator pod assignment. |
| testkube-operator.apiFullname | string | `"testkube-api-server"` | Testkube API full name |
| testkube-operator.apiPort | int | `8088` | Testkube API port |
| testkube-operator.enabled | bool | `true` |  |
| testkube-operator.extraEnvVars | list | `[]` | Extra environment variables to be set on deployment |
| testkube-operator.fullnameOverride | string | `"testkube-operator"` | Testkube Operator fullname override |
| testkube-operator.healthcheckPort | int | `8081` | Testkube Operator healthcheck port |
| testkube-operator.image.digest | string | `""` | Testkube Operator image digest |
| testkube-operator.image.pullPolicy | string | `""` | Testkube Operator image pull policy |
| testkube-operator.image.pullSecrets | list | `[]` | Operator k8s secret for private registries |
| testkube-operator.image.registry | string | `"docker.io"` | Testkube Operator registry |
| testkube-operator.image.repository | string | `"kubeshop/testkube-operator"` | Testkube Operator repository |
| testkube-operator.installCRD | bool | `true` | should the CRDs be installed |
| testkube-operator.livenessProbe.initialDelaySeconds | int | `3` | Initial delay seconds for liveness probe |
| testkube-operator.metricsServiceName | string | `""` | Name of the metrics server. If not specified, default name from the template is used |
| testkube-operator.nameOverride | string | `"testkube-operator"` | Testkube Operator name override |
| testkube-operator.namespace | string | `""` |  |
| testkube-operator.nodeSelector | object | `{}` | Node labels for Testkube Operator pod assignment. |
| testkube-operator.podAnnotations | object | `{}` |  |
| testkube-operator.podLabels | object | `{}` |  |
| testkube-operator.podSecurityContext | object | `{}` | Testkube Operator Pod Security Context |
| testkube-operator.preUpgrade.annotations | object | `{}` |  |
| testkube-operator.preUpgrade.enabled | bool | `true` | Upgrade hook is enabled |
| testkube-operator.preUpgrade.image | object | `{"pullPolicy":"IfNotPresent","pullSecrets":[],"registry":"docker.io","repository":"bitnami/kubectl","tag":"1.28.2"}` | Specify image |
| testkube-operator.preUpgrade.labels | object | `{}` |  |
| testkube-operator.preUpgrade.podAnnotations | object | `{}` |  |
| testkube-operator.preUpgrade.podSecurityContext | object | `{}` | Upgrade Pod Security Context |
| testkube-operator.preUpgrade.resources | object | `{}` | Specify resource limits and requests |
| testkube-operator.preUpgrade.securityContext | object | `{}` | Security Context for Upgrade kubectl container |
| testkube-operator.preUpgrade.serviceAccount | object | `{"create":true}` | Create SA for upgrade hook |
| testkube-operator.preUpgrade.tolerations | list | `[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]` | Tolerations to schedule a workload to nodes with any architecture type. Required for deployment to GKE cluster. |
| testkube-operator.preUpgrade.ttlSecondsAfterFinished | int | `100` |  |
| testkube-operator.priorityClassName | string | `""` |  |
| testkube-operator.proxy.image.pullSecrets | list | `[]` | Testkube Operator rbac-proxy k8s secret for private registries |
| testkube-operator.proxy.image.registry | string | `"gcr.io"` | Testkube Operator rbac-proxy image registry |
| testkube-operator.proxy.image.repository | string | `"kubebuilder/kube-rbac-proxy"` | Testkube Operator rbac-proxy image repository |
| testkube-operator.proxy.image.tag | string | `"v0.8.0"` | Testkube Operator rbac-proxy image tag |
| testkube-operator.proxy.resources | object | `{}` | Testkube Operator rbac-proxy resource settings |
| testkube-operator.rbac.create | bool | `true` |  |
| testkube-operator.readinessProbe | object | `{"initialDelaySeconds":3}` | Testkube Operator Readiness Probe parameters |
| testkube-operator.readinessProbe.initialDelaySeconds | int | `3` | Initial delay seconds for readiness probe |
| testkube-operator.replicaCount | int | `1` | Number of Testkube Operator Pod replicas |
| testkube-operator.resources | object | `{}` | Testkube Operator resource settings |
| testkube-operator.securityContext | object | `{"readOnlyRootFilesystem":true}` | Security Context for manager Container |
| testkube-operator.securityContext.readOnlyRootFilesystem | bool | `true` | Make root filesystem of the container read-only |
| testkube-operator.service.port | int | `80` | HTTP Port |
| testkube-operator.service.type | string | `"ClusterIP"` | Adapter service type |
| testkube-operator.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| testkube-operator.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| testkube-operator.serviceAccount.name | string | `""` | If not set and create is true, a name is generated using the fullname template |
| testkube-operator.terminationGracePeriodSeconds | int | `10` | Terminating a container that failed its liveness or startup probe after 10s |
| testkube-operator.testConnection | object | `{"enabled":true,"resources":{},"tolerations":[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]}` | Test Connection pod |
| testkube-operator.testConnection.resources | object | `{}` | Test Connection resource settings |
| testkube-operator.testConnection.tolerations | list | `[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]` | Tolerations to schedule a workload to nodes with any architecture type. Required for deployment to GKE cluster. |
| testkube-operator.tolerations | list | `[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]` | Tolerations to schedule a workload to nodes with any architecture type. Required for deployment to GKE cluster. |
| testkube-operator.useArgoCDSync | bool | `false` | Use ArgoCD sync owner references |
| testkube-operator.volumes.secret.defaultMode | int | `420` | Testkube Operator webhook certificate volume default mode |
| testkube-operator.webhook.annotations | object | `{}` | Webhook specific annotations |
| testkube-operator.webhook.certificate | object | `{"secretName":"webhook-server-cert"}` | Webhook certificate |
| testkube-operator.webhook.certificate.secretName | string | `"webhook-server-cert"` | Webhook certificate secret name |
| testkube-operator.webhook.createSecretJob.resources | object | `{}` |  |
| testkube-operator.webhook.enabled | bool | `true` | Use webhook |
| testkube-operator.webhook.labels | object | `{}` | Webhook specific labels |
| testkube-operator.webhook.migrate.backoffLimit | int | `1` | Number of retries before considering a Job as failed |
| testkube-operator.webhook.migrate.enabled | bool | `true` | Deploy Migrate Job |
| testkube-operator.webhook.migrate.image.pullPolicy | string | `"IfNotPresent"` | Migrate container job image pull policy |
| testkube-operator.webhook.migrate.image.pullSecrets | list | `[]` | Migrate container job k8s secret for private registries |
| testkube-operator.webhook.migrate.image.registry | string | `"docker.io"` | Migrate container job image registry |
| testkube-operator.webhook.migrate.image.repository | string | `"rancher/kubectl"` | Migrate container job image name |
| testkube-operator.webhook.migrate.image.version | string | `"v1.23.7"` | Migrate container job image tag |
| testkube-operator.webhook.migrate.resources | object | `{}` | Migrate job resources settings |
| testkube-operator.webhook.migrate.securityContext | object | `{"readOnlyRootFilesystem":true}` | Security Context for webhook migrate Container |
| testkube-operator.webhook.migrate.securityContext.readOnlyRootFilesystem | bool | `true` | Make root filesystem of the container read-only |
| testkube-operator.webhook.migrate.ttlSecondsAfterFinished | int | `100` |  |
| testkube-operator.webhook.name | string | `"testkube-operator-webhook-admission"` | Name of the webhook |
| testkube-operator.webhook.patch.annotations | object | `{}` | Annotations to add to the patch Job |
| testkube-operator.webhook.patch.createSecretJob.resources | object | `{}` | kube-webhook-certgen create secret Job resource settings |
| testkube-operator.webhook.patch.createSecretJob.securityContext | object | `{"readOnlyRootFilesystem":true}` | Security Context for webhook create container |
| testkube-operator.webhook.patch.createSecretJob.securityContext.readOnlyRootFilesystem | bool | `true` | Make root filesystem of the container read-only |
| testkube-operator.webhook.patch.enabled | bool | `true` |  |
| testkube-operator.webhook.patch.image.pullPolicy | string | `"Always"` | patch job image pull policy |
| testkube-operator.webhook.patch.image.pullSecrets | list | `[]` | patch job k8s secret for private registries |
| testkube-operator.webhook.patch.image.registry | string | `"docker.io"` | patch job image registry |
| testkube-operator.webhook.patch.image.repository | string | `"dpejcev/kube-webhook-certgen"` | patch job image name |
| testkube-operator.webhook.patch.image.version | string | `"1.0.11"` | patch job image tag |
| testkube-operator.webhook.patch.labels | object | `{}` | Pod specific labels |
| testkube-operator.webhook.patch.nodeSelector | object | `{"kubernetes.io/os":"linux"}` | Node labels for pod assignment |
| testkube-operator.webhook.patch.patchWebhookJob.resources | object | `{}` | kube-webhook-certgen patch webhook Job resource settings |
| testkube-operator.webhook.patch.patchWebhookJob.securityContext | object | `{"readOnlyRootFilesystem":true}` | Security Context for webhook patch container |
| testkube-operator.webhook.patch.patchWebhookJob.securityContext.readOnlyRootFilesystem | bool | `true` | Make root filesystem of the container read-only |
| testkube-operator.webhook.patch.podAnnotations | object | `{}` | Pod annotations to add to the patch Job |
| testkube-operator.webhook.patch.podSecurityContext | object | `{}` | kube-webhook-certgen Job Security Context |
| testkube-operator.webhook.patch.serviceAccount.annotations | object | `{}` | SA specific annotations |
| testkube-operator.webhook.patch.serviceAccount.name | string | `"testkube-operator-webhook-cert-mgr"` | SA name |
| testkube-operator.webhook.patch.tolerations | list | `[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]` | Tolerations to schedule a workload to nodes with any architecture type. Required for deployment to GKE cluster. |
| testkube-operator.webhook.patch.ttlSecondsAfterFinished | int | `100` |  |
| testkube-operator.webhook.patchWebhookJob.resources | object | `{}` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.3](https://github.com/norwoodj/helm-docs/releases/v1.11.3)
