output "argocd_namespace" {
  description = "Argo CD namespace"
  value       = kubernetes_namespace_v1.argocd.metadata[0].name
}

output "argocd_release_name" {
  description = "Argo CD Helm release name"
  value       = helm_release.argocd.name
}

output "argocd_server_service" {
  description = "Argo CD external LoadBalancer service name"
  value       = kubernetes_service_v1.argocd_server_lb.metadata[0].name
}

output "django_app_release_name" {
  description = "Argo CD Application Helm release name"
  value       = helm_release.django_app.name
}
