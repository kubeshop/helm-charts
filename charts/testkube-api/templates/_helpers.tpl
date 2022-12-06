{{/*
Expand the name of the chart.
*/}}
{{- define "testkube-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "testkube-api.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
API labels
*/}}
{{- define "testkube-api.labels" -}}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{ include "global.labels.standard" . }}
{{ include "testkube-api.selectorLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "testkube-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "testkube-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Monitoring labels
*/}}
{{- define "testkube-api.monitoring" -}}
app: prometheus
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "testkube-api.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "testkube-api.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Define API image
*/}}
{{- define "testkube-api.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := default .Chart.AppVersion .Values.image.tag | toString -}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
      {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
      {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{/*
NATS Uri
*/}}
{{- define "testkube-api.nats.uri" -}}
"nats://{{ .Release.Name }}-nats"
{{- end }}

{{/*
Define slackEvents
*/}}
{{- define "testkube-api.slackEvents" -}}
{{- $list := list }}
{{- range .Values.slackEvents }}
{{- $list = append $list (printf "\"%s\"" .) }}
{{- end }}
{{- join ", " $list }}
{{- end }}
