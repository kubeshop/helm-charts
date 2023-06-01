# testkube

Testkube is an open-source platform that simplifies the deployment and management of automated testing infrastructure.

![Version: 1.9.141](https://img.shields.io/badge/Version-1.9.141-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

## Install

IMPORTANT!

Please note that there was a bug related to the label changes that caused some issues during upgrade to newer versions. 
It was valid for versions `1.9.143` - `1.9.151`. It has been fixed since version `1.9.152`.

For those who are still using the affected versions, there are two ways to address this issue:
1. Reinstall the Testkube helm-chart. 

OR 

2. Upgrade to the latest version setting empty values for the following parameters in `values.yaml`:
```aidl
testkube-api:
  fullnameOverride: ""
  nameOverride: ""

testkube-dashboard:  
  fullnameOverride: ""
  nameOverride: ""
```

Add `kubeshop` Helm repository and fetch latest charts info:

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

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../global | global | 0.1.1 |
| file://../testkube-api | testkube-api | 1.9.32 |
| file://../testkube-dashboard | testkube-dashboard | 1.10.0 |
| file://../testkube-operator | testkube-operator | 1.9.4 |
| https://charts.bitnami.com/bitnami | mongodb | 12.1.31 |
| https://nats-io.github.io/k8s/helm/charts/ | nats | 0.19.1 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global | object | `{"annotations":{},"imagePullSecrets":[],"imageRegistry":"","labels":{}}` | Global image parameters |
| global.annotations | object | `{}` | Annotations to add to all deployed objects |
| global.imagePullSecrets | list | `[]` | Global Docker registry secret names as an array |
| global.imageRegistry | string | `""` | Global Docker image registry |
| global.labels | object | `{}` | Labels to add to all deployed objects |
| mongodb.auth.enabled | bool | `false` | Toggle whether to enable MongoDB authentication |
| mongodb.containerSecurityContext | string | `nil` | Security Context for MongoDB container |
| mongodb.enabled | bool | `true` | Toggle whether to install MongoDB |
| mongodb.fullnameOverride | string | `"testkube-mongodb"` | MongoDB fullname override |
| mongodb.image.registry | string | `"docker.io"` | MongoDB image registry |
| mongodb.image.repository | string | `"zcube/bitnami-compat-mongodb"` | MongoDB image repository |
| mongodb.image.tag | string | `"5.0.10-debian-11-r19"` | MongoDB image tag |
| mongodb.podSecurityContext | string | `nil` | MongoDB Pod Security Context |
| mongodb.resources | object | `{"requests":{"cpu":"150m","memory":"100Mi"}}` | MongoDB resource settings |
| mongodb.service | object | `{"clusterIP":"","nodePort":true,"port":"27017","portName":"mongodb"}` | MongoDB service settings |
| mongodb.tolerations | list | `[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]` | Tolerations to schedule a workload to nodes with any architecture type. Required for deployment to GKE cluster. |
| nats.exporter.resources | object | `{}` | Exporter resources settings |
| nats.exporter.securityContext | object | `{}` | Security Context for Exporter container |
| nats.fullnameOverride | string | `"testkube-nats"` |  |
| nats.nats.resources | object | `{}` | NATS resource settings |
| nats.nats.securityContext | object | `{}` | Security Context for NATS container |
| nats.natsbox.securityContext | object | `{}` | Security Context for NATS Box container |
| nats.natsbox.tolerations | list | `[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]` | NATS Box tolerations settings |
| nats.reloader.securityContext | object | `{}` | Security Context for Reloader container |
| nats.securityContext | object | `{}` | NATS Pod Security Context |
| nats.tolerations | list | `[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]` | Tolerations to schedule a workload to nodes with any architecture type. Required for deployment to GKE cluster. |
| preUpgradeHook | object | `{"enabled":true,"name":"mongodb-upgrade","podSecurityContext":{},"resources":{},"securityContext":{},"serviceAccount":{"create":true},"tolerations":[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]}` | MongoDB pre-upgrade parameters |
| preUpgradeHook.enabled | bool | `true` | Upgrade hook is enabled |
| preUpgradeHook.name | string | `"mongodb-upgrade"` | Upgrade hook name |
| preUpgradeHook.podSecurityContext | object | `{}` | MongoDB Upgrade Pod Security Context |
| preUpgradeHook.resources | object | `{}` | Specify resource limits and requests |
| preUpgradeHook.securityContext | object | `{}` | Security Context for MongoDB Upgrade kubectl container |
| preUpgradeHook.serviceAccount | object | `{"create":true}` | Create SA for upgrade hook |
| preUpgradeHook.tolerations | list | `[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]` | Tolerations to schedule a workload to nodes with any architecture type. Required for deployment to GKE cluster. |
| testkube-api.analyticsEnabled | bool | `true` | Enable analytics for Testkube |
| testkube-api.podStartTimeout | string | `30m` | Testkube timeout for pod start |
| testkube-api.cdeventsTarget | string | `""` | target for cdevents emission via http(s) |
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
| testkube-api.dashboardUri | string | `""` | dashboard uri to be used in notification events |
| testkube-api.executors | string | `""` | default executors as base64-encoded string |
| testkube-api.extraEnvVars | list | `[]` | Extra environment variables to be set on deployment |
| testkube-api.fullnameOverride | string | `"testkube-api-server"` | Testkube API fullname override |
| testkube-api.image.digest | string | `""` | Testkube API image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag |
| testkube-api.image.pullPolicy | string | `"IfNotPresent"` | Testkube API image tag |
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
| testkube-api.minio.image | object | `{"registry":"docker.io","repository":"minio/minio","tag":"latest"}` | Minio image from DockerHub |
| testkube-api.minio.minioRootPassword | string | `"minio123"` | Root password |
| testkube-api.minio.minioRootUser | string | `"minio"` | Root username |
| testkube-api.minio.nodeSelector | object | `{}` | Node labels for pod assignment. |
| testkube-api.minio.podSecurityContext | object | `{}` | MinIO Pod Security Context |
| testkube-api.minio.resources | object | `{}` | MinIO Resources settings |
| testkube-api.minio.securityContext | object | `{}` | Security Context for MinIO container |
| testkube-api.minio.serviceAccountName | string | `""` | ServiceAccount name to use for Minio |
| testkube-api.minio.storage | string | `"10Gi"` | PVC Storage Request for MinIO. Should be available in the cluster. |
| testkube-api.minio.tolerations | list | `[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]` | Tolerations to schedule a workload to nodes with any architecture type. Required for deployment to GKE cluster. |
| testkube-api.mongodb.allowDiskUse | bool | `true` | Allow or prohibit writing temporary files on disk when a pipeline stage exceeds the 100 megabyte limit. |
| testkube-api.mongodb.dsn | string | `"mongodb://testkube-mongodb:27017"` | MongoDB DSN |
| testkube-api.nats.enabled | bool | `true` | Use NATS |
| testkube-api.nats.uri | string | `"nats://testkube-nats:4222"` | NATS URI |
| testkube-api.podSecurityContext | object | `{}` | Testkube API Pod Security Context |
| testkube-api.prometheus.enabled | bool | `false` | Use monitoring |
| testkube-api.prometheus.interval | string | `"15s"` | Scrape interval |
| testkube-api.prometheus.monitoringLabels | object | `{}` | The name of the label to use in serviceMonitor if Prometheus is enabled |
| testkube-api.rbac.createRoleBindings | bool | `true` | Toggle whether to install Testkube API RBAC roles bindings |
| testkube-api.rbac.createRoles | bool | `true` | Toggle whether to install Testkube API RBAC roles |
| testkube-api.readinessProbe | object | `{"initialDelaySeconds":30}` | Testkube API Readiness probe parameters |
| testkube-api.readinessProbe.initialDelaySeconds | int | `30` | Initial delay for readiness probe |
| testkube-api.resources | object | `{"requests":{"cpu":"200m","memory":"200Mi"}}` | Testkube API resource requests and limits |
| testkube-api.securityContext | object | `{}` | Security Context for testkube-api container |
| testkube-api.service.annotations | object | `{}` | Service Annotations |
| testkube-api.service.labels | object | `{}` | Service labels |
| testkube-api.service.port | int | `8088` | HTTP Port |
| testkube-api.service.type | string | `"ClusterIP"` | Adapter service type |
| testkube-api.slackConfig | string | `""` | Slack config for the events, tests, testsuites and channels as base64-encoded string |
| testkube-api.slackSecret | string | `""` | Slack secret to store slackToken, the key name should be SLACK_TOKEN |
| testkube-api.slackTemplate | string | `""` | Slack template for the events sent to Slack as base64-encoded string |
| testkube-api.slackToken | string | `""` | Slack token from the testkube authentication endpoint |
| testkube-api.storage.SSL | bool | `false` | MinIO Use SSL |
| testkube-api.storage.accessKey | string | `"minio123"` | MinIO Secret Access Key |
| testkube-api.storage.accessKeyId | string | `"minio"` | MinIO Access Key ID |
| testkube-api.storage.bucket | string | `"testkube-artifacts"` | MinIO Bucket |
| testkube-api.storage.expiration | int | `0` | MinIO Expiration in days |
| testkube-api.storage.endpoint | string | `""` | MinIO endpoint |
| testkube-api.storage.endpoint_port | string | `"9000"` | MinIO endpoint port |
| testkube-api.storage.region | string | `""` | MinIO Region |
| testkube-api.storage.scrapperEnabled | bool | `true` | Toggle whether to enable scraper in Testkube API |
| testkube-api.storage.token | string | `""` | MinIO Token |
| testkube-api.testConnection.enabled | bool | `true` | Toggle whether to create Test Connection pod |
| testkube-api.testConnection.resources | object | `{}` | Test Connection resource settings |
| testkube-api.testConnection.tolerations | list | `[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]` | Tolerations to schedule a workload to nodes with any architecture type. Required for deployment to GKE cluster. |
| testkube-api.tolerations | list | `[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]` | Tolerations to schedule a workload to nodes with any architecture type. Required for deployment to GKE cluster. |
| testkube-api.uiIngress.annotations | object | `{}` | Additional annotations for the Ingress resource. |
| testkube-api.uiIngress.enabled | bool | `false` | Use Ingress |
| testkube-api.uiIngress.hosts | list | `["testkube.example.com"]` | Hostnames must be provided if Ingress is enabled. |
| testkube-api.uiIngress.path | string | `"/results/(v\\d/.*)"` |  |
| testkube-api.uiIngress.tls | list | `[]` | Placing a host in the TLS config will indicate a certificate should be created |
| testkube-api.uiIngress.tlsenabled | bool | `false` |  |
| testkube-dashboard | object | `{"affinity":{},"apiServerEndpoint":"","autoscaling":{"annotations":{},"enabled":false,"labels":{},"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80,"targetMemoryUtilizationPercentage":80},"enabled":true,"extraEnvVars":[],"fullnameOverride":"testkube-dashboard","image":{"digest":"","pullPolicy":"IfNotPresent","registry":"docker.io","repository":"kubeshop/testkube-dashboard"},"ingress":{"annotations":{},"enabled":false,"hosts":[],"labels":{},"path":"/","ipv6enabled":false,"tls":[],"tlsenabled":false},"nodeSelector":{},"oauth2":{"annotations":{},"args":[],"enabled":false,"env":{"clientId":"","clientSecret":"","cookieSecret":"","cookieSecure":"false","githubOrg":"","redirectUrl":"http://testkube.example.com/oauth2/callback"},"extraEnvVars":[],"image":{"pullPolicy":"Always","registry":"quay.io","repository":"oauth2-proxy/oauth2-proxy","tag":"latest"},"ingress":{"labels":{}},"labels":{},"name":"oauth2-proxy","path":"/oauth2","podAnnotations":{},"podLabels":{},"port":4180,"serviceAnnotations":{},"serviceLabels":{},"serviceType":"ClusterIP"},"podAnnotations":{},"podLabels":{},"podSecurityContext":{},"replicaCount":1,"resources":{},"securityContext":{},"service":{"annotations":{},"port":8080,"type":"ClusterIP"},"serviceAccount":{"annotations":{},"create":true,"name":""},"testConnection":{"enabled":true,"resources":{},"tolerations":[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]},"tolerations":[{"effect":"NoSchedule","key":"kubernetes.io/arch","operator":"Equal","value":"arm64"}]}` | Testkube Dashboard parameters |
| testkube-dashboard.affinity | object | `{}` | Note: podAffinityPreset, podAntiAffinityPreset, and nodeAffinityPreset will be ignored when it's set |
| testkube-dashboard.apiServerEndpoint | string | `""` | Testkube API Server endpoint |
| testkube-dashboard.disableTelemetry | bool | `false` | Force disabling telemetry on the UI |
| testkube-dashboard.autoscaling.annotations | object | `{}` | Specific autoscaling annotations |
| testkube-dashboard.autoscaling.enabled | bool | `false` | Enable autoscaling for Testkube dashboard deployment |
| testkube-dashboard.autoscaling.labels | object | `{}` | Specific autoscaling labels |
| testkube-dashboard.autoscaling.maxReplicas | int | `100` | Maximum number of replicas to scale out |
| testkube-dashboard.autoscaling.minReplicas | int | `1` | Minimum number of replicas to scale back |
| testkube-dashboard.autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU utilization percentage |
| testkube-dashboard.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Target Memory utilization percentage |
| testkube-dashboard.enabled | bool | `true` | Deploy dashboard |
| testkube-dashboard.extraEnvVars | list | `[]` | Extra environment variables to be set on deployment |
| testkube-dashboard.fullnameOverride | string | `"testkube-dashboard"` | Full name that overrides Chart name |
| testkube-dashboard.image.digest | string | `""` | Dashboard Image digest. If set, will override the tag |
| testkube-dashboard.image.pullPolicy | string | `"IfNotPresent"` | Dashboard image tag |
| testkube-dashboard.image.registry | string | `"docker.io"` | Dashboard image registry. Can be overridden by global parameters |
| testkube-dashboard.image.repository | string | `"kubeshop/testkube-dashboard"` | Dashboard image name |
| testkube-dashboard.ingress | object | `{"annotations":{},"enabled":false,"hosts":[],"labels":{},"path":"/","ipv6enabled":false,"tls":[],"tlsenabled":false}` | Ingress parameters |
| testkube-dashboard.ingress.annotations | object | `{}` | Additional annotations for the Ingress resource. |
| testkube-dashboard.ingress.enabled | bool | `false` | Use ingress |
| testkube-dashboard.ingress.hosts | list | `[]` | Hostnames must be provided if Ingress is enabled. |
| testkube-dashboard.ingress.labels | object | `{}` | Specific Ingress labels |
| testkube-dashboard.ingress.path | string | `"/"` | Path to controller |
| testkube-dashboard.ingress.tls | list | `[]` | Placing a host in the TLS config will indicate a certificate should be created |
| testkube-dashboard.nodeSelector | object | `{}` | Node labels for pod assignment. |
| testkube-dashboard.oauth2.annotations | object | `{}` | Oauth2 specific annotations |
| testkube-dashboard.oauth2.args | list | `[]` | Array of args for oauth2 provider or github as default |
| testkube-dashboard.oauth2.enabled | bool | `false` | Use oauth |
| testkube-dashboard.oauth2.env | object | `{"clientId":"","clientSecret":"","cookieSecret":"","cookieSecure":"false","githubOrg":"","redirectUrl":"http://testkube.example.com/oauth2/callback"}` | Pod environment variables for Teskube UI authentication |
| testkube-dashboard.oauth2.env.clientId | string | `""` | Client ID from Github OAuth application |
| testkube-dashboard.oauth2.env.clientSecret | string | `""` | Client Secret from Github OAuth application |
| testkube-dashboard.oauth2.env.cookieSecret | string | `""` | cookie secret generated using OpenSSL |
| testkube-dashboard.oauth2.env.cookieSecure | string | `"false"` | false for http connection, true for https connections |
| testkube-dashboard.oauth2.env.githubOrg | string | `""` | if you need to provide access only to members of your organization |
| testkube-dashboard.oauth2.env.redirectUrl | string | `"http://testkube.example.com/oauth2/callback"` | "http://demo.testkube.io/oauth2/callback" |
| testkube-dashboard.oauth2.extraEnvVars | list | `[]` | Array with extra environment variables to add to Locator nodes |
| testkube-dashboard.oauth2.image.pullPolicy | string | `"Always"` | Oauth Image pull policy |
| testkube-dashboard.oauth2.image.registry | string | `"quay.io"` | Oauth image registry. Can be overridden by global parameters |
| testkube-dashboard.oauth2.image.repository | string | `"oauth2-proxy/oauth2-proxy"` | Oauth image name |
| testkube-dashboard.oauth2.image.tag | string | `"latest"` | Oauth image tag |
| testkube-dashboard.oauth2.ingress | object | `{"labels":{}}` | Add additional Ingress labels |
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
| testkube-operator.apiPort | int | `8088` | Testkube Operator port |
| testkube-operator.extraEnvVars | list | `[]` | Extra environment variables to be set on deployment |
| testkube-operator.fullnameOverride | string | `"testkube-operator"` |  |
| testkube-operator.healthcheckPort | int | `8081` | Testkube Operator healthcheck port |
| testkube-operator.image.digest | string | `""` | Testkube Operator image digest |
| testkube-operator.image.pullPolicy | string | `""` | Testkube Operator image pull policy |
| testkube-operator.image.registry | string | `"docker.io"` | Testkube Operator registry |
| testkube-operator.image.repository | string | `"kubeshop/testkube-operator"` | Testkube Operator repository |
| testkube-operator.installCRD | bool | `true` | should the CRDs be installed |
| testkube-operator.livenessProbe.initialDelaySeconds | int | `3` | Initial delay seconds for liveness probe |
| testkube-operator.metricsServiceName | string | `""` | Name of the metrics server. If not specified, default name from the template is used |
| testkube-operator.nodeSelector | object | `{}` | Node labels for Testkube Operator pod assignment. |
| testkube-operator.podSecurityContext | object | `{}` | Testkube Operator Pod Security Context |
| testkube-operator.proxy.image.registry | string | `"gcr.io"` | Testkube Operator rbac-proxy image registry |
| testkube-operator.proxy.image.repository | string | `"kubebuilder/kube-rbac-proxy"` | Testkube Operator rbac-proxy image repository |
| testkube-operator.proxy.image.tag | string | `"v0.8.0"` | Testkube Operator rbac-proxy image tag |
| testkube-operator.proxy.resources | object | `{}` | Testkube Operator rbac-proxy resource settings |
| testkube-operator.rbac.createRoleBindings | bool | `true` | should the operator create the RBAC role bindings |
| testkube-operator.rbac.createRoles | bool | `true` | should the operator create the RBAC roles |
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
| testkube-operator.volumes.secret.defaultMode | int | `420` | Testkube Operator webhook certificate volume default mode |
| testkube-operator.webhook.annotations | object | `{}` | Webhook specific annotations |
| testkube-operator.webhook.certificate | object | `{"secretName":"webhook-server-cert"}` | Webhook certificate |
| testkube-operator.webhook.certificate.secretName | string | `"webhook-server-cert"` | Webhook certificate secret name |
| testkube-operator.webhook.enabled | bool | `true` | Use webhook |
| testkube-operator.webhook.labels | object | `{}` | Webhook specific labels |
| testkube-operator.webhook.migrate.backoffLimit | int | `1` | Number of retries before considering a Job as failed |
| testkube-operator.webhook.migrate.enabled | bool | `true` | Deploy Migrate Job |
| testkube-operator.webhook.migrate.image.pullPolicy | string | `"Always"` | Migrate container job image pull policy |
| testkube-operator.webhook.migrate.image.registry | string | `"docker.io"` | Migrate container job image registry |
| testkube-operator.webhook.migrate.image.repository | string | `"rancher/kubectl"` | Migrate container job image name |
| testkube-operator.webhook.migrate.image.version | string | `"v1.23.7"` | Migrate container job image tag |
| testkube-operator.webhook.migrate.resources | object | `{}` | Migrate job resources settings |
| testkube-operator.webhook.migrate.securityContext | object | `{"readOnlyRootFilesystem":true}` | Security Context for webhook migrate Container |
| testkube-operator.webhook.migrate.securityContext.readOnlyRootFilesystem | bool | `true` | Make root filesystem of the container read-only |
| testkube-operator.webhook.name | string | `"testkube-operator-webhook-admission"` | Name of the webhook |
| testkube-operator.webhook.patch.annotations | object | `{}` | Annotations to add to the patch Job |
| testkube-operator.webhook.patch.createSecretJob.resources | object | `{}` | kube-webhook-certgen create secret Job resource settings |
| testkube-operator.webhook.patch.createSecretJob.securityContext | object | `{"readOnlyRootFilesystem":true}` | Security Context for webhook create container |
| testkube-operator.webhook.patch.createSecretJob.securityContext.readOnlyRootFilesystem | bool | `true` | Make root filesystem of the container read-only |
| testkube-operator.webhook.patch.enabled | bool | `true` |  |
| testkube-operator.webhook.patch.image.pullPolicy | string | `"Always"` | patch job image pull policy |
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

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
