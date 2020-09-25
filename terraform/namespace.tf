resource "kubernetes_namespace" "trivago" {
  metadata {
    name = "trivago"
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}