resource "aws_iam_role" "eks" {
  name = "${var.env}-${var.eks_name}-eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com" 
      }
    }
  ]
}
POLICY
} 
# eks who is allowed to use this policy
# This is the trust policy, which defines who is allowed to assume this role.

# Field	       Meaning
# "Effect": "Allow"	Allows the action described
# "Action": "sts:AssumeRole"	Grants the ability to assume this role  (assume means who can use this role) 
# "Principal": {"Service": "eks.amazonaws.com"}	Only the EKS service is allowed to assume this role
# A Trust Policy defines who is allowed to assume (use) an IAM Role.

# It's not about what the role can do — that’s handled by permissions policies.

# It’s about who or what can use the role.

resource "aws_iam_role_policy_attachment" "eks" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"  // policy is a collection of permissions
    # This policy allows the EKS service to manage the cluster and its resources.
  role    = aws_iam_role.eks.name
}
#  role can be attached with many policies

resource "aws_eks_cluster" "eks" {
  name     = "${var.env}-${var.eks_name}"
  version  = var.eks_version
  role_arn = aws_iam_role.eks.arn

  vpc_config {
  
  ### this responsible how to access the cluster from inside vpc or outside
    endpoint_private_access = false
    endpoint_public_access  = true

    subnet_ids = [
      aws_subnet.private_zone1.id,
      aws_subnet.private_zone2.id
    ]
    # This is the subnets where the EKS control plane will be deployed.
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }
#   authentication_mode = "API"	 Uses AWS API authentication (IAM roles/groups) for accessing the cluster
#   bootstrap_cluster_creator_admin_permissions = true  The person who created the cluster (via Terraform) gets admin access automatically — a nice shortcut when first building the cluster
  depends_on = [aws_iam_role_policy_attachment.eks]
    # This ensures that the IAM role policy attachment is created before the EKS cluster.
}