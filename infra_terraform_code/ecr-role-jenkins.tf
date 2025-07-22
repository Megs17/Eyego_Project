# must be created by oicd method
data "aws_iam_policy_document" "service-account-policy-ecr" {
   statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:jenkins:ecr-access-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}
resource "aws_iam_role" "ecr_access" {
  name               = "${aws_eks_cluster.eks.name}-ecr-access-role"
  assume_role_policy = data.aws_iam_policy_document.service-account-policy-ecr.json
}
# This role is used by the Jenkins to access ECR.
resource "aws_iam_role_policy_attachment" "ecr_full_access" {
  role       = aws_iam_role.ecr_access.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}