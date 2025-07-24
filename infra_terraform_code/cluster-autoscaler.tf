resource "aws_iam_role" "cluster_autoscaler" {
  name = "${aws_eks_cluster.eks.name}-cluster-autoscaler"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "cluster_autoscaler" {
  name = "${aws_eks_cluster.eks.name}-cluster-autoscaler"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:DescribeTags",
          "ec2:DescribeImages",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:GetInstanceTypesFromInstanceRequirements",
          "eks:DescribeNodegroup"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
        ]
        Resource = "*"
      },
    ]
  })
}
## firts statement allows the cluster autoscaler to read the current state of the ASG and EC2 instances.
## second statement allows the cluster autoscaler to change the desired capacity of the ASG and terminate instances in the ASG.

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  policy_arn = aws_iam_policy.cluster_autoscaler.arn
  role       = aws_iam_role.cluster_autoscaler.name
}

resource "aws_eks_pod_identity_association" "cluster_autoscaler" {
  cluster_name    = aws_eks_cluster.eks.name
  namespace       = "kube-system"
  service_account = "cluster-autoscaler"
  role_arn        = aws_iam_role.cluster_autoscaler.arn
}
## helm release for cluster autoscaler
## The Cluster Autoscaler is a Kubernetes component that automatically adjusts the size of a cluster based on the current resource usage.
## It scales up the cluster when there are pending pods that cannot be scheduled due to insufficient resources and scales down when there are underutilized nodes.
## It is particularly useful in cloud environments where you pay for the resources you use.
resource "helm_release" "cluster_autoscaler" {
  name = "autoscaler"

  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  version    = "9.46.0"
  atomic           = true
  cleanup_on_fail  = true
  timeout          = 600  # 10 minutes
  max_history      = 5    # Keep some history for rollback
## pass service account name to the chart
set = [
    {
      name  = "rbac.serviceAccount.name"
      value = "cluster-autoscaler"
    },
    {
      name  = "autoDiscovery.clusterName"
      value = aws_eks_cluster.eks.name
    },
    {
      name  = "awsRegion"
      value = "us-east-1"
    }
  ]

  depends_on = [aws_eks_node_group.general]  ## 5le 28lb helm releases y4t8lo b3d node group
}