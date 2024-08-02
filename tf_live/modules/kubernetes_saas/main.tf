resource "kubernetes_namespace" "atlas_saas" {
  metadata {
    name = "atlas-saas"
  }
}