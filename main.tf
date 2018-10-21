provider "kubernetes" {
  config_context_cluster = "docker-for-desktop-cluster"
  config_context_auth_info = "docker-for-desktop"
  username = "docker-for-desktop"
}

resource "kubernetes_namespace" "echo" {
  metadata {
    name = "echo-ns"
  }
}

resource "kubernetes_pod" "echo" {
  metadata {
    name = "echo-pod"
    namespace = "${kubernetes_namespace.echo.metadata.0.name}"
    labels {
      App = "echo"
    }
  }
  spec {
    container {
      image = "hashicorp/http-echo:0.2.1"
      name  = "example-pod"
      args = ["-listen=:80", "-text='Hello World Terraform'"]
      port {
        container_port = 80
      }
    }
  }
}

resource "kubernetes_service" "echo" {
  metadata {
    name = "echo-service"
    namespace = "${kubernetes_namespace.echo.metadata.0.name}"
  }
  spec {
    selector {
      App = "${kubernetes_pod.echo.metadata.0.labels.App}"
    }
    port {
      port        = 10080
      target_port = 80
    }
    type = "LoadBalancer"
} }

output "lb_ip" {
  value = "${kubernetes_service.echo.load_balancer_ingress}"
}


