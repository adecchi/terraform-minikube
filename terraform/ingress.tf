resource "kubernetes_ingress" "trivago-canary-ingress" {
  metadata {
    name      = "trivago-canary-ingress"
    namespace = "trivago"
    annotations = {
      "nginx.ingress.kubernetes.io/canary"         = "true"
      "nginx.ingress.kubernetes.io/canary-weight"  = "70"
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }
  spec {
    rule {
      host = "canary-demo.trivago.com"
      http {
        path {
          backend {
            service_name = "trivago-golang-services"
            service_port = 80
          }
          path = "/"
        }
      }
    }
  }
  depends_on = [kubernetes_service.trivago-golang-services]
}

resource "kubernetes_ingress" "trivago-ingress" {
  metadata {
    name      = "trivago-ingress"
    namespace = "trivago"
  }
  spec {
    rule {
      host = "canary-demo.trivago.com"
      http {
        path {
          backend {
            service_name = "trivago-java-services"
            service_port = 80
          }
          path = "/"
        }
      }
    }
  }
  depends_on = [kubernetes_service.trivago-java-services]
}