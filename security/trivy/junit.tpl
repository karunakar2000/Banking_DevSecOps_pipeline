{{- /*
security/trivy/junit.tpl
Template to convert Trivy scan results to JUnit XML for Azure DevOps.
*/ -}}
<?xml version="1.0" encoding="UTF-8"?>
<testsuites>
  {{- range .Results }}
  <testsuite name="{{ .Target }}" tests="{{ len .Vulnerabilities }}" failures="{{ len .Vulnerabilities }}">
    {{- if not .Vulnerabilities }}
    <testcase name="{{ .Target }} - no vulnerabilities"/>
    {{- else }}
      {{- range .Vulnerabilities }}
      <testcase classname="{{ .PkgName }}" name="{{ .VulnerabilityID }} ({{ .Severity }})">
        <failure message="{{ .Title | xml }}">
          <![CDATA[
Severity: {{ .Severity }}
Target:   {{ $.Target }}
Package:  {{ .PkgName }}
Installed Version: {{ .InstalledVersion }}
Fixed Version:     {{ .FixedVersion }}
Description:       {{ .Description }}
References:
{{- range .References }}
- {{ . }}
{{- end }}
          ]]>
        </failure>
      </testcase>
      {{- end }}
    {{- end }}
  </testsuite>
  {{- end }}
</testsuites>
