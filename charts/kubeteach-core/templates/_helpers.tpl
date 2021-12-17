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

{{- define "kubeteach.selectorLabelsWebterminal" -}}
app.kubernetes.io/name: {{ include "kubeteach.name" . }}-webterminal
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "kubeteach.webterminalServiceAccountName" -}}
{{- default (printf "%s-webterminal" (include "kubeteach.name" .)) .Values.webterminal.serviceAccount.name }}
{{- end }}


{{- define "kubeteach.serviceAccountName" -}}
{{- default (include "kubeteach.name" .) .Values.serviceAccount.name }}
{{- end }}


{{- define "kubeteach.dashboardBasicAuthPassword" -}}
{{- $secret := (lookup "v1" "Secret" .Release.Namespace (include "kubeteach.name" .) ) -}}
  {{- if and $secret.data (not .Values.dashboard.credentials.password) -}}
    {{-  index $secret "data" "password" | b64dec -}}
  {{- else -}}
    "{{ .Values.dashboard.credentials.password | default (randAlphaNum 40 )}}"
  {{- end -}}
{{- end -}}

{{- define "kubeteach.webterminalCredentials" -}}
{{- $secret := (lookup "v1" "Secret" .Release.Namespace (printf "%s-webterminal" (include "kubeteach.name" .)) ) -}}
  {{- if and $secret.data (not .Values.webterminal.credentials.password) -}}
    {{-  index $secret "data" "credentials" | b64dec -}}
  {{- else -}}
    "{{ (.Values.webterminal.credentials.username | default "terminal" )}}:{{ .Values.webterminal.credentials.password | default (randAlphaNum 40 )}}"
  {{- end -}}
{{- end -}}