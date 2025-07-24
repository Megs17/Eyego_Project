# Eyego Project

**Eyego** is a cloud infrastructure project for deploying a scalable Node.js Express application on **Amazon EKS (Elastic Kubernetes Service)**. It features an automated CI/CD pipeline using Jenkins, seamless certificate management, cluster autoscaling, persistent storage, and ingress routing — all provisioned via **Terraform** and managed with **Helm**.

---

## 📌 Features

- **Application**: Lightweight Node.js Express API (returns `{"message": "Hello Eyego"}`) deployed with 2 replicas
- **CI/CD Pipeline**: Jenkins (`v5.8.49`) automates:
  - Docker image builds using **Kaniko**
  - Push to Amazon ECR `020737256003.dkr.ecr.us-east-1.amazonaws.com/eyego`
  - Deploy to EKS via Kubernetes manifests
- **Cluster Autoscaler**: Dynamically scales EKS nodes (1–10 `t3.medium`) using Cluster Autoscaler (`v9.46.0`)
- **Ingress**: External access via NGINX Ingress Controller (`v4.10.1`) exposed with a LoadBalancer
- **TLS & HTTPS**: Certificate management via **cert-manager** with Let’s Encrypt
- **Persistent Storage**: AWS EBS CSI Driver (`v1.30.0-eksbuild.1`) and StorageClass `ebs-sc`
- **Security**:
  - OIDC-based IAM role assumption using **EKS Pod Identity Agent**
  - RBAC for Jenkins to deploy to EKS
- **Networking**: VPC (`10.0.0.0/16`) with public & private subnets, NAT Gateway, and Internet Gateway

---

## 🛠 Prerequisites

Make sure the following are installed and configured:

| Tool             | Version / Note                                      |
|------------------|-----------------------------------------------------|
| AWS Account       | Permissions for EKS, IAM, VPC, and ECR             |
| Terraform         | v1.5+                                              |
| Helm              | For Kubernetes package management                  |
| AWS CLI           | Configured with valid access keys credentials      |
|`kubectl`          | For interacting with the EKS cluster               |
| Docker            | For local builds and testing                       |

**Variables (defaults):**
```hcl
region      = "us-east-1"
env         = "dev"
eks_name    = "testing-eks"
eks_version = "1.32"
zone1       = "us-east-1a"
zone2       = "us-east-1b"
```

---

## ⚙️ Installation & Deployment

### 1. Clone the Repository
```bash
git clone https://github.com/Megs17/Eyego_Project.git
cd Eyego_Project
```

### 2. Initialize Terraform
```bash
cd infra_terraform_code
terraform init
```

### 3. Configure Environment Variables 0r Use Default
Create a `terraform.tfvars` file:
```hcl
region      = "us-east-1"
env         = "dev"
eks_name    = "testing-eks"
eks_version = "1.32"
zone1       = "us-east-1a"
zone2       = "us-east-1b"
```

### 4. Apply Infrastructure
```bash
terraform plan
terraform apply
```

> This provisions the full infrastructure including VPC, EKS, node groups, Jenkins, Ingress, autoscaler, EBS CSI, and cert-manager.

### 5. Configure `kubectl`
```bash
aws eks update-kubeconfig --region us-east-1 --name testing-eks
```

### 6. CI/CD Deployment via Jenkins

Jenkins will:
- Checkout code
- Build and push Docker image using Kaniko to ECR
- Update image in `manifests/app-deployment.yaml`
- Deploy app using Kubernetes manifests (`Deployment`, `Service`, `Ingress`)


---

## 🌐 Usage

| Feature        | URL / Command                                 |
|----------------|-----------------------------------------------|
| **App Access** | https://helloapp.zapto.org                    |
| **Jenkins UI** | https://jenkins.zapto.org (`admin:admin`)     |
| **Autoscaler** | `kubectl logs -n kube-system -l app=cluster-autoscaler` |
| **TLS Certs**  | `kubectl get certificate -n jenkins`          |

---

## 📁 Project Structure

```
Eyego_Project/
│
├── hello-eyego-app/
│   ├── Dockerfile
│   └── index.js
│
├── manifests/
│   ├── app-deployment.yaml
│   ├── app-service.yaml
│   └── ingress.yaml
│
|
├── Jenkinsfile
|
├── infra_terraform_code/
│   ├── cert-manager.tf 
│   ├── cluster-autoscaler.tf
│   ├── ebs-csi-driver.tf
│   ├── ecr-role-jenkins.tf
│   ├── eks.tf
│   ├── eks-storage-class.tf
│   ├── helm_provider.tf
│   ├── igw.tf
│   ├── ingress-nginx.tf
│   ├── jenkins-rolebinding.tf
│   ├── jenkins.tf
│   ├── kubernetes-jenkins-role.tf
│   ├── letsencrypt-issuer.tf
│   ├── nat.tf
│   ├── nodes.tf
│   ├── oidc.tf
│   ├── pod-identity-addon.tf
│   ├── providers.tf
│   ├── routes.tf
│   ├── service-account-ecr.tf
│   ├── subnets.tf
│   ├── variables.tf
│   └── vpc.tf
|   ├── values/
│             └── jenkins-values.yaml
└── README.md
```

---

## 🧩 Main Terraform Modules

| File                         | Purpose                                  |
|------------------------------|------------------------------------------|
| `eks.tf`                     | EKS cluster and node group setup         |
| `vpc.tf`, `subnets.tf`       | Network infrastructure                   |
| `jenkins.tf`                 | Jenkins on Kubernetes                    |
| `cert-manager.tf`            | TLS management with Let's Encrypt        |
| `cluster-autoscaler.tf`      | Auto-scaling EKS nodes                   |
| `ebs-csi-driver.tf`          | Persistent volumes via AWS EBS           |
| `ingress-nginx.tf`           | Ingress controller setup                 |
| `oidc.tf`, `pod-identity-addon.tf` | IAM identity and access             |
| `ecr-role-jenkins.tf`        | IAM permissions for Jenkins & ECR        |
| `jenkins-rolebinding.tf`     | RBAC access for Jenkins                  |

---

## 🙏 Acknowledgments

- [Terraform](https://www.terraform.io/)
- [Helm](https://helm.sh/)
- [AWS EKS](https://aws.amazon.com/eks/)
- [Kaniko](https://github.com/GoogleContainerTools/kaniko)
- [cert-manager](https://cert-manager.io/)
- [Cluster Autoscaler](https://github.com/kubernetes/autoscaler)
- [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
- [EBS CSI Driver](https://github.com/kubernetes-sigs/aws-ebs-csi-driver)
- [Jenkins](https://www.jenkins.io/)

---
# Live Demo Links

- [Jenkins Dashboard](https://jenkins.zapto.org/) (username:admin  password:admin)
- [Hello Eyego App](https://helloapp.zapto.org/)

> **Note:** These services are hosted on the AWS Free Tier and may be temporarily unavailable if AWS suspends them due to free tier usage limits. 
> If the links are down, please check the recorded video demonstration instead.

## 📬 Contact

Feel free to reach out:
- Email: [ahmedfec2000@gmail.com](mailto:ahmedfec2000@gmail.com)
- GitHub: [Ahmed Magdy](https://github.com/Megs17)
