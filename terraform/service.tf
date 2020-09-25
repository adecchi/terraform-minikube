resource "kubernetes_service" "trivago-java-services" {
  metadata {
    name      = "trivago-java-services"
    namespace = "trivago"
  }
  timeouts {
    create = "30s" # for testing errors
  }
  spec {
    selector = {
      app = kubernetes_deployment.trivago-java-webserver.spec.0.template.0.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "NodePort"
  }
  depends_on = [kubernetes_deployment.trivago-java-webserver]
}

resource "kubernetes_service" "trivago-golang-services" {
  metadata {
    name      = "trivago-golang-services"
    namespace = "trivago"
  }
  timeouts {
    create = "30s" # for testing errors
  }
  spec {
    selector = {
      app = kubernetes_deployment.trivago-golang-webserver.spec.0.template.0.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "NodePort"
  }
  depends_on = [kubernetes_deployment.trivago-golang-webserver]
}

# InfluxDB Services
resource "kubernetes_service" "influxdb-services" {
  metadata {
    name      = "influxdb-services"
    namespace = "monitoring"
  }
  timeouts {
    create = "30s" # for testing errors
  }
  spec {
    selector = {
      app = kubernetes_deployment.influxdb.spec.0.template.0.metadata[0].labels.app
    }
    port {
      port        = 8086
      target_port = 8086
    }
    type = "ClusterIP"
  }
  depends_on = [kubernetes_deployment.influxdb]
}

# Grafana Services
resource "kubernetes_service" "grafana-services" {
  metadata {
    name      = "grafana-services"
    namespace = "monitoring"
  }
  timeouts {
    create = "30s" # for testing errors
  }
  spec {
    selector = {
      app = kubernetes_deployment.grafana.spec.0.template.0.metadata[0].labels.app
    }
    port {
      port        = 3000
      target_port = 3000
    }
    type = "LoadBalancer"
  }
  depends_on = [kubernetes_deployment.grafana]
}

# Telegraf Services
resource "kubernetes_service" "telegraf-services" {
  metadata {
    name      = "telegraf-services"
    namespace = "monitoring"
  }
  timeouts {
    create = "30s" # for testing errors
  }
  spec {
    selector = {
      app = kubernetes_deployment.telegraf.spec.0.template.0.metadata[0].labels.app
    }
    port {
      port        = 8125
      target_port = 8125
    }
    type = "NodePort"
  }
  depends_on = [kubernetes_deployment.telegraf]
}

# Prometheus Services
resource "kubernetes_service" "prometheus-services" {
  metadata {
    name      = "prometheus-services"
    namespace = "monitoring"
  }
  timeouts {
    create = "30s" # for testing errors
  }
  spec {
    selector = {
      app = "prometheus"
    }
    port {
      port        = 9090
      target_port = 9090
    }
    type = "NodePort"
  }
  depends_on = [helm_release.prometheus]
}