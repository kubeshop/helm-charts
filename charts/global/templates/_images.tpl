{{/*
Return the proper image name
{{ include "global.images.image" ( dict "imageRoot" .Values.path.to.the.image "global" $) }}
*/}}
{{- define "global.images.image" -}}
{{- $separator := ":" -}}
{{- $imageDict := .imageRoot -}}
{{- if .global }}
    {{- $imageDict := merge .imageRoot (dict "registry" .global.imageRegistry) -}}
{{- end -}}
{{- if $imageDict.registry }}
    {{- printf "%s/%s%s%s" $imageDict.registry $imageDict.repository $separator $imageDict.tag -}}
{{- else -}}
    {{- printf "%s%s%s" $imageDict.repository $separator $imageDict.tag -}}
{{- end -}}
{{- end -}}


{{/*
Return the proper Docker Image Registry Secret Names evaluating values as templates
{{ include "global.images.renderPullSecrets" . }}
*/}}
{{- define "global.images.renderPullSecrets" -}}
{{- $global := .Values.global }}

{{- if $global.imagePullSecrets }}
imagePullSecrets:
    {{- range $global.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end }}
{{- end -}}