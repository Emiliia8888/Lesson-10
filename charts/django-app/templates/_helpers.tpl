{{- define "django-app.name" -}}
{{- .Chart.Name -}}
{{- end -}}

{{- define "django-app.fullname" -}}
{{- .Release.Name -}}
{{- end -}}
