{{/*
Override the nats.image template to use .global.imageRegistry instead of their
.global.image.registry.
*/}}
{{- define "nats.image" }}
{{- $image := printf "%s:%s" .repository .tag }}
{{- if or .registry .global.imageRegistry }}
{{- $image = printf "%s/%s" (.registry | default .global.imageRegistry) $image }}
{{- end -}}
image: {{ $image }}
{{- if or .pullPolicy .global.image.pullPolicy }}
imagePullPolicy: {{ .pullPolicy | default .global.image.pullPolicy }}
{{- end }}
{{- end }}
