{{- define "kubeteach.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "kubeteach.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "kubeteach.labels" -}}
helm.sh/chart: {{ include "kubeteach.chart" . }}
{{ include "kubeteach.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "kubeteach.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kubeteach.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "kubeteach.serviceAccountName" -}}
{{- default (include "kubeteach.name" .) .Values.serviceAccount.name }}
{{- end }}
