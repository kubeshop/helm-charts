{{/* Job template for prebuilt executors */}}
{{- define "testkube-api.job-template" -}}
apiVersion: batch/v1
kind: Job
metadata:
  name: "{{`{{ .Name }}`}}"
  namespace: {{`{{ .Namespace }}`}}
  {{- with .Values.jobAnnotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{`{{- if gt .ActiveDeadlineSeconds 0 }}`}}
  activeDeadlineSeconds: {{`{{ .ActiveDeadlineSeconds }}`}}
  {{`{{- end }}`}}
  template:
    {{- with .Values.jobPodAnnotations }}
    metadata:
      annotations:
        {{- toYaml . | nindent 8 }}
    {{- end }}
    spec:
      initContainers:
      - name: {{`{{ .Name }}`}}-init
        {{`{{- if .Registry }}`}}
        image: {{`{{ .Registry }}`}}/{{`{{ .InitImage }}`}}
        {{`{{- else }}`}}
        image: {{`{{ .InitImage }}`}}
        {{`{{- end }}`}}
        imagePullPolicy: IfNotPresent
        command:
          - "/bin/runner"
          - '{{`{{ .Jsn }}`}}'
        {{`{{- if .RunnerCustomCASecret }}`}}
        env:
          - name: SSL_CERT_DIR
            value: /etc/testkube/certs
          - name: GIT_SSL_CAPATH
            value: /etc/testkube/certs
        {{`{{- end }}`}}
        volumeMounts:
        {{`{{- if not (and  .ArtifactRequest (eq .ArtifactRequest.VolumeMountPath "/data")) }}`}}
        - name: data-volume
          mountPath: /data
        {{`{{ end }}`}}
        {{`{{- if .CertificateSecret }}`}}
        - name: {{`{{ .CertificateSecret }}`}}
          mountPath: /etc/certs
        {{`{{- end }}`}}
        {{`{{- if .RunnerCustomCASecret }}`}}
        - name: {{`{{ .RunnerCustomCASecret }}`}}
          mountPath: /etc/testkube/certs/testkube-custom-ca.pem
          readOnly: true
          subPath: ca.crt
        {{`{{- end }}`}}
        {{`{{- if .ArtifactRequest }}`}}
          {{`{{- if and .ArtifactRequest.VolumeMountPath (or .ArtifactRequest.StorageClassName .ArtifactRequest.UseDefaultStorageClassName) }}`}}
        - name: artifact-volume
          mountPath: {{`{{ .ArtifactRequest.VolumeMountPath }}`}}
          {{`{{- end }}`}}
        {{`{{- end }}`}}
        {{`{{- range $configmap := .EnvConfigMaps }}`}}
        {{`{{- if and $configmap.Mount $configmap.Reference }}`}}
        - name: {{`{{ $configmap.Reference.Name }}`}}
          mountPath: {{`{{ $configmap.MountPath }}`}}
        {{`{{- end }}`}}
        {{`{{- end }}`}}
        {{`{{- range $secret := .EnvSecrets }}`}}
        {{`{{- if and $secret.Mount $secret.Reference }}`}}
        - name: {{`{{ $secret.Reference.Name }}`}}
          mountPath: {{`{{ $secret.MountPath }}`}}
        {{`{{- end }}`}}
        {{`{{- end }}`}}
        {{- with .Values.additionalJobVolumeMounts }}
        {{- toYaml . | nindent 8 -}}
        {{- end }}
      containers:
      {{`{{ if .Features.LogsV2 -}}`}}
      - name: "{{`{{ .Name }}`}}-logs"
        {{`{{- if .Registry }}`}}
        image: {{`{{ .Registry }}`}}/{{`{{ .LogSidecarImage }}`}}
        {{`{{- else }}`}}
        image: {{`{{ .LogSidecarImage }}`}}
        {{`{{- end }}`}}
        imagePullPolicy: IfNotPresent
        env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: DEBUG
          value: {{`{{ if .Debug }}`}}"true"{{`{{ else }}`}}"false"{{`{{ end }}`}}
        - name: NAMESPACE
          value: {{`{{ .Namespace }}`}}
        - name: NATS_URI
          value: {{`{{ .NatsUri }}`}}
        - name: ID
          value: {{`{{ .Name }}`}}
        - name: GROUP
          value: test
        - name: SOURCE
          value: "job-pod:{{`{{ .Name }}`}}"
      {{`{{- end }}`}}
      - name: "{{`{{ .Name }}`}}"
        {{`{{- if .Registry }}`}}
        image: {{`{{ .Registry }}`}}/{{`{{ .Image }}`}}
        {{`{{- else }}`}}
        image: {{`{{ .Image }}`}}
        {{`{{- end }}`}}
        imagePullPolicy: IfNotPresent
        command:
          - "/bin/runner"
          - '{{`{{ .Jsn }}`}}'
        {{`{{- if .RunnerCustomCASecret }}`}}
        env:
          - name: SSL_CERT_DIR
            value: /etc/testkube/certs
          - name: GIT_SSL_CAPATH
            value: /etc/testkube/certs
        {{`{{- end }}`}}
        volumeMounts:
        {{`{{- if not (and  .ArtifactRequest (eq .ArtifactRequest.VolumeMountPath "/data")) }}`}}
        - name: data-volume
          mountPath: /data
        {{`{{ end }}`}}
        {{`{{- if .CertificateSecret }}`}}
        - name: {{`{{ .CertificateSecret }}`}}
          mountPath: /etc/certs
        {{`{{- end }}`}}
        {{`{{- if .RunnerCustomCASecret }}`}}
        - name: {{`{{ .RunnerCustomCASecret }}`}}
          mountPath: /etc/testkube/certs/testkube-custom-ca.pem
          readOnly: true
          subPath: ca.crt
        {{`{{- end }}`}}
        {{`{{- if .AgentAPITLSSecret }}`}}
        - mountPath: /tmp/agent-cert
          readOnly: true
          name: {{`{{ .AgentAPITLSSecret }}`}}
        {{`{{- end }}`}}
        {{`{{- if .ArtifactRequest }}`}}
          {{`{{- if and .ArtifactRequest.VolumeMountPath (or .ArtifactRequest.StorageClassName .ArtifactRequest.UseDefaultStorageClassName) }}`}}
        - name: artifact-volume
          mountPath: {{`{{ .ArtifactRequest.VolumeMountPath }}`}}
          {{`{{- end }}`}}
        {{`{{- end }}`}}
        {{`{{- range $configmap := .EnvConfigMaps }}`}}
        {{`{{- if and $configmap.Mount $configmap.Reference }}`}}
        - name: {{`{{ $configmap.Reference.Name }}`}}
          mountPath: {{`{{ $configmap.MountPath }}`}}
        {{`{{- end }}`}}
        {{`{{- end }}`}}
        {{`{{- range $secret := .EnvSecrets }}`}}
        {{`{{- if and $secret.Mount $secret.Reference }}`}}
        - name: {{`{{ $secret.Reference.Name }}`}}
          mountPath: {{`{{ $secret.MountPath }}`}}
        {{`{{- end }}`}}
        {{`{{- end }}`}}
        {{- with .Values.additionalJobVolumeMounts }}
        {{- toYaml . | nindent 8 -}}
        {{- end }}
      volumes:
      {{`{{- if not (and  .ArtifactRequest (eq .ArtifactRequest.VolumeMountPath "/data")) }}`}}
      - name: data-volume
        emptyDir: {}
      {{`{{ end }}`}}
      {{`{{- if .CertificateSecret }}`}}
      - name: {{`{{ .CertificateSecret }}`}}
        secret:
          secretName: {{`{{ .CertificateSecret }}`}}
      {{`{{- end }}`}}
      {{`{{- if .RunnerCustomCASecret }}`}}
      - name: {{`{{ .RunnerCustomCASecret }}`}}
        secret:
          secretName: {{`{{ .RunnerCustomCASecret }}`}}
          defaultMode: 420
      {{`{{- end }}`}}
      {{`{{- if .AgentAPITLSSecret }}`}}
      - name: {{`{{ .AgentAPITLSSecret }}`}}
        secret:
          secretName: {{`{{ .AgentAPITLSSecret }}`}}
      {{`{{- end }}`}}
      {{`{{- if .ArtifactRequest }}`}}
        {{`{{- if and .ArtifactRequest.VolumeMountPath (or .ArtifactRequest.StorageClassName .ArtifactRequest.UseDefaultStorageClassName) }}`}}
      - name: artifact-volume
        persistentVolumeClaim:
          claimName: {{`{{ .Name }}`}}-pvc
        {{`{{- end }}`}}
      {{`{{- end }}`}}
      {{`{{- range $configmap := .EnvConfigMaps }}`}}
      {{`{{- if and $configmap.Mount $configmap.Reference }}`}}
      - name: {{`{{ $configmap.Reference.Name }}`}}
        configmap:
          name: {{`{{ $configmap.Reference.Name }}`}}
      {{`{{- end }}`}}
      {{`{{- end }}`}}
      {{`{{- range $secret := .EnvSecrets }}`}}
      {{`{{- if and $secret.Mount $secret.Reference }}`}}
      - name: {{`{{ $secret.Reference.Name }}`}}
        secret:
          secretName: {{`{{ $secret.Reference.Name }}`}}
      {{`{{- end }}`}}
      {{`{{- end }}`}}
      {{- with .Values.additionalJobVolumes }}
      {{- toYaml . | nindent 6 -}}
      {{- end }}
      restartPolicy: Never
      {{`{{- if .ServiceAccountName }}`}}
      serviceAccountName: {{`{{ .ServiceAccountName }}`}}
      {{`{{- end }}`}}
      {{`{{- if gt (len .ImagePullSecrets) 0 }}`}}
      imagePullSecrets:
      {{`{{- range $secret := .ImagePullSecrets }}`}}
      - name: {{`{{ $secret -}}`}}
      {{`{{- end }}`}}
      {{`{{- end }}`}}
  backoffLimit: 0
  ttlSecondsAfterFinished: 180
{{- end }}
