output "endpoint" {
  description = "Nginx ingress endpoint"
  # might need to use "hostname" for aws
  value = data.kubernetes_service.ingress.load_balancer_ingress.0
}

output "depended_on" {
  value = "${null_resource.dependency_setter.id}-${timestamp()}"
}
