{{- define "banking-app.name" -}}
{{- default .Chart.Name .Values.app.name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "banking-app.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "banking-app.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}
