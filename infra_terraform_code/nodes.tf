resource "aws_iam_role" "nodes" {
  name = "${var.env}-${var.eks_name}-eks-nodes"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
POLICY
}
## trust policy is given to ec2 instance
# # This is the trust policy, which defines who is allowed to assume this role.


# This AWS-managed policy allows EC2 worker nodes to:

# Join the EKS cluster

# Register themselves

# Pull configurations

# Communicate with EKS Control Plane APIs

# This policy now includes AssumeRoleForPodIdentity for the Pod Identity Agent

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

# This AWS-managed policy allows EC2 worker nodes to:

# Join the EKS cluster

# Register themselves

# Pull configurations

# Communicate with EKS Control Plane APIs

# AWS updated this policy to support the EKS Pod Identity feature (2024+), which allows pods to assume IAM roles more securely without needing kube2iam or IRSA complexity.

# 🔹 So, this policy supports newer EKS setups where pods assume roles directly using the Pod Identity Agent.
## explain of the pod identity agent in other file

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}
## this policy responible for the networking between the pods which allows each pod to have its own IP address

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}


resource "aws_eks_node_group" "general" {
  cluster_name    = aws_eks_cluster.eks.name
  version         = var.eks_version
  node_group_name = "general"
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = [
    aws_subnet.private_zone1.id,
    aws_subnet.private_zone2.id
  ]

  capacity_type  = "ON_DEMAND"  // feh onspot
  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 3
    max_size     = 10
    min_size     = 1
  }  
# Starts with 1 node.

# Can scale up to 10 or down to 0 based on workloads

## but still need the cluster autoscaler to scale the nodes up and down

  update_config {
    max_unavailable = 1
  }
# When upgrading the node group, EKS will allow 1 node at a time to be unavailable.


  labels = {
    role = "general"
  }
#  Useful in Kubernetes node selectors or affinity rules.
#  mmkn ykon 3ndk node type bta3a general w node tanya type bta3ha gpu flabel yshl 3lek n5tar ezay lmkan 

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]

  # Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
#   Let’s say an autoscaler increases desired_size to 3.

# Without ignore_changes:
# Terraform will notice desired_size = 3, but your code says 1, so it'll try to revert it back.

# With ignore_changes:
# Terraform will skip applying changes to desired_size, and leave it at 3
}