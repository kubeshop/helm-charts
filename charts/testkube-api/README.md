# testkube-api

![Version: 1.15.2](https://img.shields.io/badge/Version-1.15.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.15.2](https://img.shields.io/badge/AppVersion-1.15.2-informational?style=flat-square)

A Helm chart for Testkube api

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../global | global | 0.1.2 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalNamespaces | list | `[]` |  |
| affinity | object | `{}` |  |
| analyticsEnabled | bool | `true` |  |
| autoscaling.annotations | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.labels | object | `{}` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| cdeventsTarget | string | `""` |  |
| cliIngress.annotations | object | `{}` |  |
| cliIngress.enabled | bool | `false` |  |
| cliIngress.hosts | list | `[]` |  |
| cliIngress.labels | object | `{}` |  |
| cliIngress.oauth.clientID | string | `""` |  |
| cliIngress.oauth.clientSecret | string | `""` |  |
| cliIngress.oauth.provider | string | `"github"` |  |
| cliIngress.oauth.scopes | string | `""` |  |
| cliIngress.path | string | `"/results/(v\\d/.*)"` |  |
| cliIngress.tls | list | `[]` |  |
| cliIngress.tlsenabled | bool | `false` |  |
| cloud.envId | string | `""` |  |
| cloud.existingSecret.envId | string | `""` |  |
| cloud.existingSecret.key | string | `""` |  |
| cloud.existingSecret.name | string | `""` |  |
| cloud.existingSecret.orgId | string | `""` |  |
| cloud.key | string | `""` |  |
| cloud.migrate | string | `""` |  |
| cloud.orgId | string | `""` |  |
| cloud.url | string | `"agent.testkube.io:443"` |  |
| cloud.uiUrl | string | `""` |  |
| clusterName | string | `""` |  |
| configValues | string | `""` |  |
| dashboardUri | string | `""` |  |
| dnsPolicy | string | `""` |  |
| disableMongoMigrations | bool | `false` |  |
| enableSecretsEndpoint | bool | `false` |  |
| executors | string | `""` |  |
| extraEnvVars | object | `{}` |  |
| fullnameOverride | string | `""` |  |
| global.annotations | object | `{}` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.imageRegistry | string | `""` |  |
| global.labels | object | `{}` |  |
| hostNetwork | string | `""` |  |
| httpReadBufferSize | int | `8192` |  |
| image.digest | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.pullSecret | list | `[]` |  |
| image.registry | string | `"docker.io"` |  |
| image.repository | string | `"kubeshop/testkube-api-server"` |  |
| enabledExecutors | object | `{}` |  |
| jobServiceAccountName | string | `""` |  |
| kubeVersion | string | `""` |  |
| livenessProbe.initialDelaySeconds | int | `30` |  |
| logs.bucket | string | `"testkube-logs"` |  |
| logs.storage | string | `"minio"` |  |
| minio.accessModes[0] | string | `"ReadWriteOnce"` |  |
| minio.affinity | object | `{}` |  |
| minio.enabled | bool | `true` |  |
| minio.extraEnvVars | object | `{}` |  |
| minio.extraVolumeMounts | list | `[]` |  |
| minio.extraVolumes | list | `[]` |  |
| minio.image.pullPolicy | string | `"IfNotPresent"` |  |
| minio.image.pullSecrets | list | `[]` |  |
| minio.image.registry | string | `"docker.io"` |  |
| minio.image.repository | string | `"minio/minio"` |  |
| minio.image.tag | string | `"2023.2.27"` |  |
| minio.livenessProbe.initialDelaySeconds | int | `3` |  |
| minio.livenessProbe.periodSeconds | int | `10` |  |
| minio.matchLabels | list | `[]` |  |
| minio.minioRootPassword | string | `""` |  |
| minio.minioRootUser | string | `""` |  |
| minio.nodeSelector | object | `{}` |  |
| minio.podSecurityContext | object | `{}` |  |
| minio.priorityClassName | string | `""` |  |
| minio.readinessProbe.initialDelaySeconds | int | `3` |  |
| minio.readinessProbe.periodSeconds | int | `10` |  |
| minio.replicaCount | int | `1` |  |
| minio.resources | object | `{}` |  |
| minio.secretPasswordKey | string | `""` |  |
| minio.secretPasswordName | string | `""` |  |
| minio.secretUserKey | string | `""` |  |
| minio.secretUserName | string | `""` |  |
| minio.securityContext | object | `{}` |  |
| minio.serviceAccountName | string | `""` |  |
| minio.storage | string | `"10Gi"` |  |
| minio.tolerations | list | `[]` |  |
| mongodb.allowDiskUse | bool | `true` |  |
| mongodb.dsn | string | `"mongodb://testkube-mongodb:27017"` |  |
| multinamespace.enabled | bool | `false` |  |
| nameOverride | string | `""` |  |
| nats.enabled | bool | `true` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| podStartTimeout | string | `"30m"` | Testkube timeout for pod start |
| priorityClassName | string | `""` |  |
| prometheus.enabled | bool | `false` |  |
| prometheus.interval | string | `"15s"` |  |
| prometheus.monitoringLabels | object | `{}` |  |
| rbac.create | bool | `true` |  |
| readinessProbe.initialDelaySeconds | int | `45` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.annotations | object | `{}` |  |
| service.labels | object | `{}` |  |
| service.port | int | `8088` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| slackConfig | string | `""` |  |
| slackSecret | string | `""` |  |
| slackToken | string | `""` |  |
| storage.SSL | bool | `false` |  |
| storage.accessKey | string | `""` |  |
| storage.accessKeyId | string | `""` |  |
| storage.bucket | string | `"testkube-artifacts"` |  |
| storage.compressArtifacts | bool | `true` |  |
| storage.endpoint | string | `""` |  |
| storage.endpoint_port | string | `"9000"` |  |
| storage.expiration | int | `0` |  |
| storage.region | string | `""` |  |
| storage.scrapperEnabled | bool | `true` |  |
| storage.secretKeyAccessKeyId | string | `""` |  |
| storage.secretKeySecretAccessKey | string | `""` |  |
| storage.secretNameAccessKeyId | string | `""` |  |
| storage.secretNameSecretAccessKey | string | `""` |  |
| storage.token | string | `""` |  |
| templates.job | string | `""` |  |
| templates.jobContainer | string | `""` |  |
| templates.pvcContainer | string | `""` |  |
| templates.scraperContainer | string | `""` |  |
| templates.slavePod | string | `""` |  |
| testConnection.enabled | bool | `false` |  |
| testServiceAccount.annotations | object | `{}` |  |
| testServiceAccount.create | bool | `true` |  |
| tolerations | list | `[]` |  |
| uiIngress.annotations | object | `{}` |  |
| uiIngress.enabled | bool | `false` |  |
| uiIngress.hosts | list | `[]` |  |
| uiIngress.labels | object | `{}` |  |
| uiIngress.path | string | `"/results/(v\\d/executions.*)"` |  |
| uiIngress.tls | list | `[]` |  |
| uiIngress.tlsenabled | bool | `false` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.2](https://github.com/norwoodj/helm-docs/releases/v1.11.2)
