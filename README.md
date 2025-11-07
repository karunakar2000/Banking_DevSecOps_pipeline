# Banking CI/CD & DevSecOps Pipeline — DTB Bank (Work-in-Progress)

> Short: a compact, practical repo that demonstrates the CI/CD, security scanning, artifact management, and cloud deployment work I run at DTB Bank.

## Overview
This repo contains a demo implementation of the sort of pipeline I run at DTB.  
It’s focused on delivering a small microservice to cloud in a secure, auditable way:

- Build and unit-test the app  
- Run static code analysis (SonarQube)  
- Build Docker image, scan with Trivy  
- Push artifacts to JFrog Artifactory  
- Deploy to Kubernetes (EKS/AKS) via Helm  
- Use Terraform + Ansible for infra provisioning and configuration  
- Monitor with Prometheus/Grafana and collect logs with Loki/CloudWatch

I use this as my working template to show how we enforce DevSecOps gates and promote artifacts through environments (dev → qa → prod).

## Goals
1. Keep production deployments traceable (image + artifact provenance).  
2. Fail early on code quality or critical vulnerabilities.  
3. Keep infrastructure reproducible (Terraform) and configuration idempotent (Ansible).  
4. Keep operational runbooks and alerts simple and practical.

## Architecture (high level)
```
GitHub (source)  --> Jenkins (CI) --> SonarQube (code quality)
                                --> Docker build -> Trivy scan -> JFrog (artifacts)
                                --> Terraform (infra) -> Ansible (config)
                                --> Helm deploy -> EKS/AKS (k8s)
Monitoring: Prometheus + Grafana + Loki (logs) + CloudWatch (cloud metrics)
Ingress: Traefik (k8s) with TLS termination
Secrets: Vault or Secrets manager (not in this demo)
```

## What’s in this repo

├── app/                      # sample app (Node.js or small Java service)
│   ├── src/
│   └── Dockerfile
├── jenkins/                  # Jenkinsfile and shared-library examples
│   └── Jenkinsfile
├── terraform/                # Terraform modules for VPC, EKS/AKS, storage
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── ansible/                  # Ansible playbooks for bootstrap/config
│   └── playbook.yml
├── k8s/                      # Helm chart or raw k8s manifests
│   ├── chart/
│   ├── values.yaml
│   └── deployment.yaml
├── security/                 # SonarQube conf, Trivy policy files
│   └── trivy-ignore.yaml
├── docs/                     # diagrams, runbooks, architecture notes
└── README.md
```

## Quick start (local / dev)
 This repo is a demo — it assumes you have Docker, kubectl, helm installed and access to a k8s cluster.

1. Clone:
   bash
    git clone https://github.com/<yourusername>/banking-devsecops-pipeline.git
    cd banking-devsecops-pipeline


2. Build and run the sample app locally:
   bash
    cd app
    docker build -t <your-dockerhub-username>/bank-app:dev .
    docker run -p 8080:8080 <your-dockerhub-username>/bank-app:dev
    # check http://localhost:8080


3. (Optional) Run unit tests:
    bash
    # Node example
    npm install
    npm test


## CI/CD (Jenkins) — what it does
The 'jenkins/Jenkinsfile' in this repo demonstrates a multistage pipeline:

1. Checkout → run unit tests  
2. SonarQube scan (quality gates)  
3. Build Docker image  
4. Trivy scan the image (fail on critical HIGH/CRITICAL)  
5. Push Docker image to JFrog Artifactory / Docker registry  
6. Terraform plan/apply for infra (dev env only in demo)  
7. Ansible apply to provision/config nodes (for non-k8s targets)  
8. Helm deploy to k8s cluster  
9. Post-deploy smoke tests and notify (Slack/email)

Tip:- The pipeline uses credentials stored in Jenkins (never hard-coded).

## Security & DevSecOps
- **Code quality:** SonarQube configured; pipeline aborts on quality gate failure.  
- **Image scanning:** Trivy run against image; policy configurable in security/.  
- **Artifact management:** JFrog Artifactory holds versioned artifacts; promotion is manual/automated depending on env.  
- **Secrets:** Use a secrets manager (HashiCorp Vault, AWS Secrets Manager, or Azure Key Vault). In this demo we show placeholders and avoid including real secrets.  
- **Network:** k8s network policies and Traefik ingress with TLS for production workloads.

## Terraform notes
- Terraform modules live in `terraform/`.  
- Use a remote backend (S3+DynamoDB or Azure Storage with blob + lease) in real setups — local state only for demos.  
- Example usage:
```bash
cd terraform
terraform init
terraform plan -var-file=dev.tfvars
terraform apply -auto-approve -var-file=dev.tfvars
```
- Always `terraform plan` and review before apply.

## Ansible notes
- `ansible/playbook.yml` bootstraps servers (install docker, kubelet, join cluster) or configures app nodes.  
- Credentials are passed via Ansible Vault or via Jenkins credentials injection (do not store secrets in repo).

## Helm / Kubernetes notes
- Helm chart in `k8s/chart` packages deployments, services, and ingress.  
- Image references are parameterized (so the same chart works for dev/qa/prod).  
- Deploy example (requires kubeconfig):
```bash
helm upgrade --install bank-app ./k8s/chart -f k8s/values.dev.yaml --set image.tag=dev
```

## Observability
- Export Prometheus metrics from the app (sample endpoint `/metrics`).  
- Grafana dashboards live in `docs/grafana/` (examples).  
- Loki collects logs; we show how to forward to CloudWatch for longer retention.

## What I’d expect in a real DTB project (production notes)
- Strict separation of environments with separate k8s clusters or namespaces.  
- SSO + role-based access control for all tooling (Jenkins, Artifactory, SonarQube).  
- Automated promotion workflow: artifacts promoted from dev → qa → prod (artifact immutability).  
- Policy-as-code (OPA or Terraform Cloud policies) to enforce guardrails.  
- Regular vulnerability scanning and scheduled dependency updates.

## Cleanup
If you provision demo infra, destroy it:
```bash
cd terraform
terraform destroy -auto-approve -var-file=dev.tfvars
```

## What I learned / Why I built this
I use this repo as my living template to:
- Test pipeline improvements safely,  
- Demo secure artifact flow to auditors, and  
- Quickly spin up a reproducible environment for troubleshooting.

It mirrors the kind of work I do daily at DTB: improving release reliability, reducing manual toil, and adding security gates where they matter.

## Contributing / Notes
- This repo intentionally keeps secrets out. Use Jenkins credentials and secrets managers.  
- Replace `placeholder` values with your own registry, artifactory URLs, and cloud accounts.  
- Use this as a starting point; each org will adapt modules to fit policy and compliance.

## Contact
If you want to discuss the setup or see a short screen recording of the pipeline running, ping me at:  
`github.com/<yourusername>` — I’m happy to walk through it.
