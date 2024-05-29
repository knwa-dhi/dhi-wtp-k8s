{{/*
Expand the name of the chart.
*/}}
{{- define "wtp.name" -}}
{{- default .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "wtp.fullname" -}}
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
{{- define "wtp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "wtp.labels" -}}
helm.sh/chart: {{ include "wtp.chart" . }}
{{ include "wtp.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "wtp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "wtp.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "wtp.serviceAccountName" -}}
{{- if .Values.wtpapi.serviceAccount.create }}
{{- default (include "wtp.fullname" .) .Values.wtpapi.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.wtpapi.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "imagePullSecret" }}
{{- with .Values.imageCredentials }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password .email (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}
{{- end }}

{{- define "wtp.crt" -}}
{{- .Files.Get "certs/test-com.crt.base64" | quote -}}
{{- end -}}

{{- define "wtp.key" -}}
{{- .Files.Get "certs/test-com.key.base64" | quote -}}
{{- end -}}
