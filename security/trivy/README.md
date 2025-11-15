# Trivy Integration – DTB BankingOnline

This folder contains configuration used to integrate **Trivy** container image scanning into the Azure DevOps pipelines.

## Files

- `junit.tpl`  
  Go template used by Trivy to generate **JUnit XML** output. The XML report is then published in Azure DevOps as a test result.

## Usage in Azure DevOps

Typical pipeline steps:

```bash
trivy image \
  --exit-code 0 \
  --severity LOW,MEDIUM,HIGH,CRITICAL \
  --format template \
  --template "@security/trivy/junit.tpl" \
  -o trivy-report.xml \
  myacr.azurecr.io/banking-online:$(Build.BuildId)
