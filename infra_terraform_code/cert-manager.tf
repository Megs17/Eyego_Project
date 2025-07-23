resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  create_namespace = true

  set = [{
      name  = "installCRDs"
      value = "true"
    }]
  
  depends_on = [aws_eks_node_group.general]
}
