resource "kubernetes_role" "jenkins_deployer" {
  metadata {
    name      = "eks-deployer"
    namespace = "jenkins"
  }

  rule {
    api_groups = [""]
    resources  = ["services", "pods", "pods/log"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "replicasets"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
    rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
  depends_on = [ kubernetes_service_account.ecr_access ]
}
