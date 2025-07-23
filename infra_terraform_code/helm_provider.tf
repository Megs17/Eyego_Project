## here we setup the helm provider to use in the EKS cluster
data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.eks.name
}
# aws_eks_cluster: Fetches cluster metadata like endpoint and certificate authority.


data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.eks.name
}
# aws_eks_cluster_auth: Fetches a token to authenticate with the cluster (used by Helm or kubectl).

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  kubernetes =  {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

