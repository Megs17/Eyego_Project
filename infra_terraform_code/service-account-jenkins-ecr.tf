resource "kubernetes_service_account" "ecr_access" {
  metadata {
    name      = "ecr-access-sa"
    namespace = "jenkins"

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.ecr_access.arn
    }
  }
  depends_on = [ helm_release.jenkins ]
}
# This service account is used by the Jenkins to access ECR.