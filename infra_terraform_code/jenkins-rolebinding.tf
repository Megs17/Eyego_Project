resource "kubernetes_role_binding" "jenkins_deployer_binding" {
  metadata {
    name      = "eks-deployer-binding"
    namespace = "jenkins"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.jenkins_deployer.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = "ecr-access-sa"
    namespace = "jenkins"
  }
    depends_on = [ kubernetes_service_account.ecr_access ]

}