resource "helm_release" "jenkins" {

  name = "jenkins"
  repository = "https://charts.jenkins.io"
  chart = "jenkins"
  namespace = "jenkins"
  create_namespace = true
  # Downgraded to version 5.8.47 due to compatibility issues with the current setup.
  # Ensure to monitor for updates to address potential security vulnerabilities.
  version = "5.8.47"

  values = [file("${path.module}/values/jenkins-values.yaml")]


  
  depends_on = [ aws_eks_addon.ebs_csi_driver,
  kubernetes_storage_class.ebs_sc ]
}