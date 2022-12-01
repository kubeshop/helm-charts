{{/*
Expand the name of the chart.
*/}}
{{- define "testkube-dashboard.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "testkube-dashboard.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
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
Dashboard labels
*/}}
{{- define "testkube-dashboard.labels" -}}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{ include "global.labels.standard" . }}
{{ include "testkube-dashboard.selectorLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "testkube-dashboard.selectorLabels" -}}
app.kubernetes.io/name: {{ include "testkube-dashboard.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "testkube-dashboard.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "testkube-dashboard.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Define Dashboard image
*/}}
{{- define "testkube-dashboard.image" -}}
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
Define Oauth2 selector labels
*/}}
{{- define "testkube-oauth2.selectorLabels" -}}
selector: k8s-app
{{- end }}
