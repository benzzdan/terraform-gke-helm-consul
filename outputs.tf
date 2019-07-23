# output "client_certificate" {
#   value = "${google_container_cluster.gke-cluster.master_auth.0.client_certificate}"
# }

# output "client_key" {
#   value = "${google_container_cluster.gke-cluster.master_auth.0.client_key}"
# }

output "endpoint" {
  value = "${google_container_cluster.gke-cluster.endpoint}"
}

output "master_version" {
  value = "${google_container_cluster.gke-cluster.master_version}"
}


output "cluster_ca_certificate" {
  value = "${google_container_cluster.gke-cluster.master_auth.0.cluster_ca_certificate}"
}
