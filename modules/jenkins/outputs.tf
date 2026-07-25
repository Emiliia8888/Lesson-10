output "jenkins_namespace" {
  description = "Jenkins namespace"
  value       = var.namespace
}

output "jenkins_release_name" {
  description = "Jenkins Helm release name"
  value       = helm_release.jenkins.name
}

output "jenkins_service_account" {
  description = "Jenkins Kubernetes service account"
  value       = kubernetes_service_account.jenkins.metadata[0].name
}
