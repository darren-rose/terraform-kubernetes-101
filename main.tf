provider "kubernetes" {
	config_context_cluster = "docker-for-desktop-cluster"
	config_context_auth_info = "docker-for-desktop"
	username = "docker-for-desktop"
}

resource "kubernetes_pod" "echo" {
  metadata {
    name = "echo-example"
    labels {
      App = "echo"
  } }
  spec {
    container {
      image = "hashicorp/http-echo:0.2.1"
      name  = "example2"
      args = ["-listen=:80", "-text='Hello World'"]
      port {
        container_port = 80
} } } }

resource "kubernetes_service" "echo" {
  metadata {
    name = "echo-example"
  }
  spec {
    selector {
      App = "${kubernetes_pod.echo.metadata.0.labels.App}"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
} }

output "lb_ip" {
  value = "${kubernetes_service.echo.load_balancer_ingress.0.ip}"
}


