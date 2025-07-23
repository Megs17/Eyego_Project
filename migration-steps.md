---

## 🚚 Migration Guide: AWS EKS ➜ Google Cloud GKE

This section outlines the steps to migrate the Eyego project from AWS EKS to Google Cloud Platform (GCP) using GKE.

### 🔁 Key Differences

| AWS (EKS)          | GCP (GKE)                          |
|-------------------|-------------------------------------|
| Amazon ECR         | Google Artifact Registry / GCR     |
| IAM with OIDC      | Workload Identity                  |
| VPC & Subnets      | Google VPC                         |
| EBS CSI Driver     | GCP Persistent Disks               |
| AWS LoadBalancer   | GKE LoadBalancer / Ingress         |
| Terraform AWS Provider| Terraform Google Provider       |

### 1. Prerequisites

- Google Cloud Project with:
  - Kubernetes Engine API enabled
  - Artifact Registry enabled
  - IAM & Admin API enabled

- Install:
  - `gcloud` CLI
  - Terraform
  - `kubectl`

```bash
gcloud init
gcloud auth application-default login
gcloud auth configure-docker
```

### 2. Replace Terraform AWS Modules with GCP Equivalents

Replace `infra_terraform_code/*.tf` AWS files with GCP equivalents:

```hcl
# providers.tf
provider "google" {
  project = var.project_id
  region  = var.region
}
```

Create GCP Terraform files:
- `gke.tf` (GKE cluster)
- `network.tf` (VPC/subnets)
- `artifact_registry.tf` (container image registry)
- `service_account.tf` (IAM for Jenkins)
- `workload_identity.tf` (to map K8s service accounts to GCP)

### 3. Update Jenkinsfile & Docker Push

Replace ECR image push with Artifact Registry in GCP


### 4. Configure storage class and GCP storage

- Replace `storageClassName: ebs-sc` with GCP's `standard`

### 5. Enable Workload Identity

Enable Workload Identity on the GKE cluster and create a GCP service account with necessary IAM roles.  
Annotate the Kubernetes service account to impersonate the GCP service account.  
```

### 6. Deploy and Validate

- Deploy updated manifests with GCP-compatible images and storage classes
- Access the app and Jenkins UI 
- Monitor cert-manager and scaling behavior

---