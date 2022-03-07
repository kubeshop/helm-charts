{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kusk-gateway.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kusk-gateway.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "kusk-gateway.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kusk-gateway.labels" -}}
helm.sh/chart: {{ include "kusk-gateway.chart" . }}
{{ include "kusk-gateway.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kusk-gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kusk-gateway.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use

We intend to have only one such account in the namespace, so this is hardcoded (no release name prepend)

*/}}
{{- define "kusk-gateway.serviceAccountName" -}}
{{- if .Values.serviceAccount.name }}
{{- default .Values.serviceAccount.name }}
{{- else }}
{{- default "kusk-gateway-manager" }}
{{- end }}
{{- end }}

{{- define "kusk-gateway.webhooksServiceName" -}}
{{- default "kusk-gateway-webhooks-service" }}
{{- end }}

{{- define "kusk-gateway.agentServiceName" -}}
{{- default "kusk-gateway-agent-service" }}
{{- end }}
