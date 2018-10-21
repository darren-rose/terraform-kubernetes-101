provider "kubernetes" {
  config_context_cluster = "docker-for-desktop-cluster"
  config_context_auth_info = "docker-for-desktop"
  username = "docker-for-desktop"
}

resource "kubernetes_pod" "echo" {
  metadata {
    name = "echo-pod"
    labels {
      App = "echo"
    }
  }
  spec {
    container {
      image = "hashicorp/http-echo:0.2.1"
      name  = "example2"
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


