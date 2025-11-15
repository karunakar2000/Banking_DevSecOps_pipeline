# OWASP ZAP – DAST Configuration

This folder contains supporting files and documentation for running **OWASP ZAP** as part of the DTB BankingOnline DevSecOps pipeline.

## Usage Pattern

In the Azure DevOps pipeline:

1. The application is deployed to **Staging** or **UAT**.
2. ZAP runs a **targeted scan** against the public URL of the environment.
3. The HTML or XML report is published as a build artifact and optionally converted to test results.

Example pipeline task (conceptual):

```yaml
- task: owaspzap@1
  inputs:
    scantype: 'targetedScan'
    url: 'http://staging.bankingonline.dtbbank.com'
    port: '80'
    threshold: '500'
  displayName: 'DAST scan against Staging'
  continueOnError: true
