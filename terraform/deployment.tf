resource "kubernetes_deployment" "trivago-java-webserver" {
  metadata {
    name = "trivago-java-webserver"
    labels = {
      app     = "WebserverApp-java"
      version = "v1.0"
    }
    namespace = "trivago"
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "WebserverApp-java"
      }
    }
    template {
      metadata {
        labels = {
          app     = "WebserverApp-java"
          version = "v1.0"
        }
      }
      spec {
        container {
          image = "adecchi/java-webserver:1.0"
          name  = "java-webserver-image"
          liveness_probe {
            http_get {
              path = "/health"
              port = 8080
            }
            initial_delay_seconds = 5
            period_seconds        = 10
            failure_threshold     = 2
          }
          readiness_probe {
            http_get {
              path = "/ready"
              port = 8080
            }
            period_seconds    = 1
            failure_threshold = 1
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "trivago-golang-webserver" {
  metadata {
    name = "trivago-go-webserver"
    labels = {
      app     = "WebserverApp-golang"
      version = "v2.0"
    }
    namespace = "trivago"
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "WebserverApp-golang"
      }
    }
    template {
      metadata {
        labels = {
          app     = "WebserverApp-golang"
          version = "v2.0"
        }
      }
      spec {
        container {
          image = "adecchi/golang-webserver:1.0"
          name  = "golang-webserver-image"
          liveness_probe {
            http_get {
              path = "/health"
              port = 8080
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }
          readiness_probe {
            http_get {
              path = "/ready"
              port = 8080
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}

# Grafana
resource "kubernetes_deployment" "grafana" {
  metadata {
    name = "grafana"
    labels = {
      app = "grafana"
    }
    namespace = "monitoring"
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "grafana"
      }
    }
    template {
      metadata {
        labels = {
          app = "grafana"
        }
      }
      spec {
        container {
          image = "docker.io/grafana/grafana:5.3.2"
          name  = "grafana"
          env_from {
            secret_ref {
              name = "grafana-secrets"
            }
          }
        }
      }
    }
  }
  depends_on = [kubernetes_secret.grafana-secrets]
}

# InfluxDB
resource "kubernetes_deployment" "influxdb" {
  metadata {
    name = "influxdb"
    labels = {
      app = "influxdb"
    }
    namespace = "monitoring"
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "influxdb"
      }
    }
    template {
      metadata {
        labels = {
          app = "influxdb"
        }
      }
      spec {
        container {
          image = "docker.io/influxdb:1.6.4"
          name  = "influxdb"
          env_from {
            secret_ref {
              name = "influxdb-secrets"
            }
          }
          volume_mount {
            mount_path = "/var/lib/influxdb"
            name       = "var-lib-influxdb"
          }
        }
        volume {
          name = "var-lib-influxdb"
          persistent_volume_claim {
            claim_name = "influxdb-pvc"
          }
        }
      }
    }
  }
  depends_on = [kubernetes_secret.influxdb-secrets, kubernetes_persistent_volume_claim.influxdb-pvc]
}

# Telegraf
resource "kubernetes_deployment" "telegraf" {
  metadata {
    name = "telegraf"
    labels = {
      app = "telegraf"
    }
    namespace = "monitoring"
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "telegraf"
      }
    }
    template {
      metadata {
        labels = {
          app = "telegraf"
        }
      }
      spec {
        container {
          image = "telegraf:1.10.0"
          name  = "telegraf"
          env_from {
            secret_ref {
              name = "telegraf-secrets"
            }
          }
          volume_mount {
            name       = "telegraf-config-volume"
            mount_path = "/etc/telegraf/telegraf.conf"
            sub_path   = "telegraf.conf"
            read_only  = true
          }
        }
        volume {
          name = "telegraf-config-volume"
          config_map {
            name = "telegraf-config"
          }
        }
      }
    }
  }
  depends_on = [kubernetes_deployment.influxdb, kubernetes_secret.telegraf-secrets, kubernetes_config_map.telegraf-config]
}