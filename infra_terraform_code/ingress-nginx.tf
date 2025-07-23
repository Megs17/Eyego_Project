resource "helm_release" "ingress_controller" {
  name       = "ingress-nginx"
  namespace  = "ingress-nginx"
  create_namespace = true

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.10.1"  
  
  set= [{
    name  = "controller.service.type"
    value = "LoadBalancer"
  }]
  depends_on = [aws_eks_node_group.general]  ## 5le 28lb helm releases y4t8lo b3d node group

}