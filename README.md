# DTB Banking–Cloud DevSecOps on Azure DevOps, AKS & Argo CD

This repository shows a banking DevSecOps implementation using **Azure DevOps**, **Kubernetes (AKS)**, **Helm**, and **Argo CD**, backed by **AWS and Azure infrastructure** provisioned with **Terraform**.

The code and pipelines are based on a realistic scenario from a banking client (DTB Bank), where the goal is to:

- Build and test a Spring Boot application (Banking-online, Microservice-Architecture) using Azure DevOps.
- Enforce quality and security gates with SonarQube, Trivy, and OWASP ZAP.
- Publish artifacts to JFrog Artifactory and container images to ACR / Docker Hub.
- Provision and manage cloud infrastructure in AWS and Azure using Terraform.
- Deploy and operate the application on AKS using Helm and GitOps with Argo CD.
- Support multiple environments (Dev, UAT, Prod) with controlled promotion.


The repository follows clean, production aligned layout that reflects how CI/CD, Kubernetes, and GitOps workflows are typically organized within large financial institutions. Every module is intentionally structured to demonstrate real world implementation practices and can be reused or extended for enterprise workloads.


---

## 1. High-level architecture

At a high level, the solution looks like this:

- **Source Control**: GitHub repository `banking-ado-k8s-argocd`
- **CI/CD Engine**: Azure DevOps Pipelines (YAML)
- **Application**: Spring Boot (BankingOnline sample) packaged as a JAR and then a Docker image
- **Container Registry**:
  - Azure Container Registry (ACR) for AKS deployments
  - Docker Hub as a secondary/public registry
  - JFrog Artifactory for Maven artifacts
- **Infrastructure**:
  - AWS: VPC, subnets, internet gateway, security groups, EC2 instances
  - Azure: AKS cluster, networking, and related resources (optional extension)
- **Orchestration**: Kubernetes on Azure Kubernetes Service (AKS)
- **Packaging**: Helm chart (`helm/banking-app`)
- **GitOps**: Argo CD Applications (Dev, UAT, Prod) pulling manifests/Helm from this repo
- **Security & Quality**:
  - SonarQube SAST in the CI pipeline
  - Trivy container image scanning
  - OWASP ZAP DAST against staging and production URLs
- **Monitoring & Logging** (optional placeholders):
  - Prometheus, Grafana, Loki, and ELK references for metrics and logs

The diagrams in `docs/` (for example `architecture-diagram.png` and `ci-cd-pipeline.png`) illustrate the flow from commit, through CI/CD, to production deployment.

---

## 2. Tools and technologies

**Cloud & Infra**
- Azure DevOps
- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- AWS (VPC, EC2, S3, IAM, S3 backend for Terraform state)
- Terraform (with workspaces and AssumeRole for multi-account)

**Application & Packaging**
- Java 11+ / Spring Boot (BankingOnline as a sample)
- Maven
- Docker
- Helm

**Kubernetes & GitOps**
- AKS
- Traefik Ingress Controller
- Argo CD (GitOps for Dev/UAT/Prod)

**DevSecOps**
- SonarQube (code quality and SAST)
- Trivy (container image scanning with JUnit reporting)
- OWASP ZAP (DAST against staging and prod URLs)
- JFrog Artifactory (Maven repository)
- Azure Key Vault / Variable groups / Secure files for secrets

**Monitoring & Logging (optional)**
- Prometheus, Grafana
- Loki or ELK for logs

---

## 3. Repository layout

Brief overview of the main folders:

- `app/`  
  Spring Boot application code (or a pointer to the upstream BankingOnline repo), Maven configuration, and Dockerfile. The Azure DevOps CI pipeline uses this to build the JAR and container image.

- `azure-pipelines/`  
  YAML pipelines for:
  - CI: build, test, SonarQube analysis, Trivy scan, JFrog artifact publish, ACR/Docker Hub push.
  - CD to AKS: Helm-based deployment to Dev/UAT/Prod.
  - Infrastructure: Terraform pipelines for AWS VPC/EC2 and optionally AKS networking.
  - Shared templates to avoid repetition (tool checks, Terraform job templates, AssumeRole, workspaces).

- `infra/aws/`  
  Terraform configuration that:
  - Creates a VPC, subnets, internet gateway, route tables, and security groups.
  - Provisions EC2 instances for legacy or supporting services.
  - Uses environment-specific `*.tfvars` files (`dev.tfvars`, `uat.tfvars`, `prod.tfvars`).
  - Optionally uses AWS AssumeRole and workspaces to target multiple accounts from a single Azure DevOps pipeline.

- `infra/azure/`  
  Placeholder Terraform configuration for AKS and related networking. This can be wired into `azure-pipelines-infra-azure.yml` as needed.

- `k8s/`  
  Base Kubernetes manifests (namespace, deployment, service, ingress, configmap) and overlays per environment. Traefik is used as the ingress controller.

- `helm/banking-app/`  
  Helm chart for the banking application:
  - Deployment, Service, Ingress, ConfigMap templates.
  - `values.yaml` for shared defaults and per-environment overrides.

- `argocd/`  
  Argo CD `Application` manifests for Dev/UAT/Prod:
  - Each Argo CD Application watches a path in this repo (Helm chart or Kustomize overlay).
  - When the Azure DevOps pipeline updates the image tag in values or Kustomize, Argo CD syncs the changes into AKS.

- `security/`  
  Configuration for SonarQube, Trivy, and OWASP ZAP integration.

- `monitoring/`  
  Optional values files / dashboard templates for Prometheus, Grafana, and Loki.

- `scripts/`  
  Helper scripts for local testing, AKS setup, and one-off deployments.

- `docs/`  
  Markdown documents and diagrams explaining architecture, CI/CD, and infrastructure.

---

## 4. CI/CD pipeline overview (Azure DevOps)

### 4.1 CI Pipeline (`azure-pipelines/azure-pipelines-ci.yml`)

Typical flow on branch `development`:

1. **Agent & tool check**  
   Ensure Terraform, Packer, Docker, and other CLIs are available on the agent.

2. **SonarQube SAST**  
   - Prepare SonarQube analysis using a service connection.
   - Run `mvn clean verify` with SonarQube integration.
   - Publish the quality gate result and optionally break the build when it fails.

3. **Build & Package**  
   - Set a version based on the build ID (e.g. `Dev-4.0.<BuildId>`).
   - Build the JAR with Maven.
   - Deploy the artifact to JFrog Artifactory.
   - Rename and store the JAR as a generic artifact for later deployment.

4. **Artifact Distribution**  
   - Upload the JAR to Azure Blob Storage for archival.
   - Upload the JAR to AWS S3 for cross-cloud scenarios (if required).

5. **Docker Build & Trivy Scan**  
   - Build a Docker image from `app/Dockerfile`.
   - Run the container locally on the agent for quick smoke testing.
   - Scan the image with Trivy and publish JUnit-style reports into Azure DevOps.
   - Optionally separate “low/medium” from “high/critical” findings.

6. **Push Image to Registries**  
   - Login and push to Azure ACR with the build tag.
   - Tag and push to Docker Hub as a public image.

This pipeline runs for development branches and can be extended or restricted via branch filters.

### 4.2 CD Pipeline to AKS (`azure-pipelines/azure-pipelines-cd-aks.yml`)

Typical flow:

1. Triggered after a successful CI on selected branches or via a manual approval.
2. Uses Helm and/or Kustomize to:
   - Update image tags in the values file for the target environment (Dev/UAT/Prod).
   - Apply changes to AKS directly (for simple deployments) **or** commit changes to the repo for Argo CD to pick up.
3. For production, additional approvals and manual gates can be enforced.

---

## 5. GitOps with Argo CD

The `argocd/` directory contains example `Application` manifests for each environment.

A typical Argo CD Application file:

- Points to this GitHub repo.
- Selects a path such as `helm/banking-app` or `k8s/overlays/prod`.
- Defines the destination cluster (the AKS API server) and namespace.
- Enables automated sync with optional pruning and self-healing.

The idea is:

- Azure DevOps handles build, test, security scanning, and image publishing.
- Argo CD watches Git (this repo) and applies the Kubernetes changes to AKS.
- This gives a clean separation between CI and CD, and a Git-based audit trail.

---

## 6. Terraform and multi-environment infrastructure

The Terraform configurations under `infra/aws/` are structured to reflect three common patterns you practised:

1. **Simple VPC + EC2 deployment** with shared variables and multiple `*.tfvars` files.
2. **Azure DevOps-driven Terraform** using:
   - Secure files (`backend.json`, `access.auto.tfvars`).
   - Variable groups for credentials.
   - Conditional logic for `plan`, `apply`, and `destroy`.
3. **AssumeRole + Workspaces**:
   - A master account is used by Azure DevOps.
   - Terraform assumes roles into target AWS accounts.
   - Workspaces such as `dev` and `prod` separate state and configuration.
   - Pipelines can selectively create/destroy resources per environment.

This mirrors how enterprises separate accounts and environments for security and governance.

---

## 7. Security & compliance

Security is integrated across the pipeline, not an afterthought:

- **SAST (SonarQube)**  
  Every main branch build checks code quality and security rules and publishes a quality gate.

- **Container scanning (Trivy)**  
  All built images are scanned. Results are converted to JUnit and surfaced in Azure DevOps test reports.

- **DAST (OWASP ZAP)**  
  After deployment to staging or production, ZAP runs a targeted scan against the application URL.  
  Results can be exported and reviewed as part of release validation.

- **Secrets management**  
  Sensitive data (AWS keys, ACR passwords, SonarQube tokens, etc.) is kept in:
  - Azure DevOps variable groups.
  - Secure files.
  - Optionally Azure Key Vault integrations.

- **IAM & RBAC**  
  AWS AssumeRole, Terraform, Kubernetes RBAC, and Azure RBAC can be layered on top of this baseline.

---

This project demonstrates an end-to-end automated deployment platform designed for the DTB Bank Online Banking System.
The solution follows modern DevSecOps and GitOps principles to deliver secure, scalable, and compliant workloads across cloud platforms.

| Capability        | Tools Implemented                                             |
| ----------------- | ------------------------------------------------------------- |
| CI Automation     | Azure DevOps                                                  |
| CD to AKS         | Helm + Kubernetes                                             |
| GitOps            | Argo CD                                                       |
| Security          | SonarQube (SAST), Trivy (image scan), Vault/JFrog credentials |
| Containerization  | Docker                                                        |
| Observability     | Prometheus + Grafana (later phase)                            |
| Cloud Providers   | Azure + AWS (artifact storage and DR strategy)                |
| Ingress / Routing | Traefik Ingress Controller                                    |


## Developer Commit => Azure DevOps CI
  - SAST with SonarQube                                                                                        
  - Build & JUnit test with Maven                                                                                
  - Container image build                                                                                      
  - Trivy image vulnerability scanning                                                                           
  - Publish image to Azure Container Registry (ACR)                                                               
  ### Trigger CD Pipeline                                                                                        
        Helm upgrade on AKS                                                                                    
        Commit new image tag to Git repo                                                                       
        Argo CD sync (GitOps)                                                                                    
        Traefik exposes application securely                                                                   


---
## 8. How to run this project (high-level)

This project can be deployed end-to-end across Azure and AKS using Azure DevOps pipelines with Helm and Argo CD. The high level steps to get started are:

**Clone the repo**

   ```bash
   git clone https://github.com/karunakar2000/Banking-ado-k8s-argocd-project.git
   cd banking-ado-k8s-argocd
