resource "helm_release" "jenkins" {

  name = "jenkins"
  repository = "https://charts.jenkins.io"
  chart = "jenkins"
  namespace = "jenkins"
  create_namespace = true
  version = "5.8.49"

  values = [file("${path.module}/values/jenkins-values.yaml")]
  
  depends_on = [ aws_eks_addon.ebs_csi_driver ]
}