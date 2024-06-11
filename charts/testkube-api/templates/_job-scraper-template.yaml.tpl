{{/* Job template for scraper jobs */}}
{{- define "testkube-api.job-scraper-template" -}}
apiVersion: batch/v1
kind: Job
metadata:
  name: {{`{{ .Name }}`}}-scraper
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
          value: scraper
        - name: SOURCE
          value: "scraper-pod:{{`{{ .Name }}`}}"
      {{`{{- end }}`}}
      - name: {{`{{ .Name }}`}}-scraper
        {{`{{- if .Registry }}`}}
        image: {{`{{ .Registry }}`}}/{{`{{ .ScraperImage }}`}}
        {{`{{- else }}`}}
        image: {{`{{ .ScraperImage }}`}}
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
        {{`{{- if .RunnerCustomCASecret }}`}}
          - name: {{`{{ .RunnerCustomCASecret }}`}}
            mountPath: /etc/testkube/certs/testkube-custom-ca.pem
            readOnly: true
            subPath: ca.crt
        {{`{{- end }}`}}
        {{`{{- if or .ArtifactRequest .AgentAPITLSSecret }}`}}
          {{`{{- if .ArtifactRequest.VolumeMountPath }}`}}
          - name: artifact-volume
            mountPath: {{`{{ .ArtifactRequest.VolumeMountPath }}`}}
          {{`{{- end }}`}}
          {{`{{- if .AgentAPITLSSecret }}`}}
          - mountPath: /tmp/agent-cert
            readOnly: true
            name: {{`{{ .AgentAPITLSSecret }}`}}
          {{`{{- end }}`}}
        {{`{{- end }}`}}
        {{- with .Values.additionalJobVolumeMounts }}
          {{- toYaml . | nindent 10 -}}
        {{- end }}
      volumes:
      {{`{{- if .RunnerCustomCASecret }}`}}
        - name: {{`{{ .RunnerCustomCASecret }}`}}
          secret:
            secretName: {{`{{ .RunnerCustomCASecret }}`}}
            defaultMode: 420
      {{`{{- end }}`}}
      {{`{{- if or .ArtifactRequest .AgentAPITLSSecret }}`}}
        {{`{{- if and .ArtifactRequest.VolumeMountPath (or .ArtifactRequest.StorageClassName .ArtifactRequest.UseDefaultStorageClassName) }}`}}
        - name: artifact-volume
          persistentVolumeClaim:
            claimName: {{`{{ .Name }}`}}-pvc
        {{`{{- end }}`}}
        {{`{{- if .AgentAPITLSSecret }}`}}
        - name: { { .AgentAPITLSSecret } }
          secret:
            secretName: {{`{{ .AgentAPITLSSecret }}`}}
        {{`{{- end }}`}}
      {{`{{- end }}`}}
      {{- with .Values.additionalJobVolumes }}
        {{- toYaml . | nindent 8 -}}
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
  ttlSecondsAfterFinished: {{`{{ .DelaySeconds }}`}}
{{- end }}
