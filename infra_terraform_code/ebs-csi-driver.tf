## trust policy used in pod identity method
data "aws_iam_policy_document" "ebs_csi_driver" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

## iam role for the ebs csi driver
## This role is used by the EBS CSI driver to manage EBS volumes.

resource "aws_iam_role" "ebs_csi_driver" {
  name               = "${aws_eks_cluster.eks.name}-ebs-csi-driver"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_driver.json
}

## This policy is used by the EBS CSI driver to manage EBS volumes.
resource "aws_iam_role_policy_attachment" "ebs_csi_driver" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_driver.name
}

resource "aws_eks_pod_identity_association" "ebs_csi_driver" {
  cluster_name    = aws_eks_cluster.eks.name
  namespace       = "kube-system"
  service_account = "ebs-csi-controller-sa" ## This is the service account used by the EBS CSI driver. by default, it is created by the EBS CSI driver Helm chart.
  role_arn        = aws_iam_role.ebs_csi_driver.arn
}

## This is the EBS CSI driver addon for EKS. It allows EKS to manage EBS volumes using the CSI (Container Storage Interface) driver.
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = aws_eks_cluster.eks.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.30.0-eksbuild.1"
  service_account_role_arn = aws_iam_role.ebs_csi_driver.arn ## This is the IAM role used by the EBS CSI driver. It allows the EBS CSI driver to manage EBS volumes using the IAM role.
}   