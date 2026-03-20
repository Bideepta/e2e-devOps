provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "flask" {
  metadata {
    name = "flask-app"
  }
}

resource "kubernetes_deployment" "flask" {
  metadata {
    name      = "flask-deployment"
    namespace = kubernetes_namespace.flask.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "flask-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "flask-app"
        }
      }

      spec {
        container {
          name  = "flask-container"
          image = "bideeptasaha/flask-app:v2"

          port {
            container_port = 8000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "flask" {
  metadata {
    name      = "flask-service"
    namespace = kubernetes_namespace.flask.metadata[0].name
  }

  spec {
    selector = {
      app = "flask-app"
    }

    port {
      port        = 8000
      target_port = 8000
    }

    type = "NodePort"
  }
}
