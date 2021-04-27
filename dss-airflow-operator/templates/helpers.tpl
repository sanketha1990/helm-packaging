{{/*
Expand the name of the chart.
*/}}
{{- define "dss-service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "dss-service.fullname" -}}
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
{{- define "dss-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "dss-service.labels" -}}
helm.sh/chart: {{ include "dss-service.chart" . }}
{{ include "dss-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "dss-service.selectorLabels" -}}
app.kubernetes.io/productSuite: {{ .Values.productSuite }}
app.kubernetes.io/name: {{ include "dss-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/tenant: {{ .Values.tenant }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "dss-service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "dss-service.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "dss-service.api.basePath" -}}
{{- $basePath := default "dss-service" (.Values.application.basePath | trimPrefix "/" | trimSuffix "/") -}}
{{- $basePath = print "/" $basePath -}}
{{ if .Values.includeTenantBasePath }}
{{- $basePath = print "/" .Values.tenant $basePath  -}}
{{ end }}
{{- print $basePath -}}
{{- end -}}

{{- define "dss-service.api.name" -}}
{{- $baseName := include "dss-service.fullname" . | trunc 40 | trimSuffix "-" }}
{{- print $baseName "-api"  -}}
{{- end }}

{{- define "dss-service.api.labels" -}}
{{ include "dss-service.selectorLabels" . }}
app.kubernetes.io/type: api
{{- end }}

{{- define "dss-service.client.name" -}}
{{- $baseName := include "dss-service.fullname" . | trunc 40 | trimSuffix "-" }}
{{- print $baseName "-client"  -}}
{{- end }}

{{- define "dss-service.client.labels" -}}
{{ include "dss-service.selectorLabels" . }}
app.kubernetes.io/type: client
{{- end }}
