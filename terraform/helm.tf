resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "prometheus"
  namespace  = "monitoring"
}
