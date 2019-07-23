data "google_client_config" "client" {}

data "google_client_openid_userinfo" "terraform_user" {}


provider "kubernetes" {
  version = "~> 1.7.0"
  host                   = "${google_container_cluster.gke-cluster.endpoint}"
  token                  = "${data.google_client_config.client.access_token}"
  cluster_ca_certificate = "${base64decode(google_container_cluster.gke-cluster.master_auth.0.cluster_ca_certificate)}"
  client_key             = "${base64decode(google_container_cluster.gke-cluster.master_auth.0.client_key)}"
  client_certificate     = "${base64decode(google_container_cluster.gke-cluster.master_auth.0.client_certificate)}"
  load_config_file       = false
}


provider "helm" {
  # We don't install Tiller automatically, but instead use Kubergrunt as it sets up the TLS certificates much easier.
  install_tiller = true
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.11.0"
  service_account = "tiller"

  kubernetes {
    host                   = "${google_container_cluster.gke-cluster.endpoint}"
    # token                  = "${data.google_client_config.client.access_token}"
    cluster_ca_certificate = "${base64decode(google_container_cluster.gke-cluster.master_auth.0.cluster_ca_certificate)}"
    client_key             = "${base64decode(google_container_cluster.gke-cluster.master_auth.0.client_key)}"
    client_certificate     = "${base64decode(google_container_cluster.gke-cluster.master_auth.0.client_certificate)}"

  }
}


resource "google_container_cluster" "gke-cluster" {
  name      = "${var.env}-gke-cluster"
  project   = "terraform-247216"
  location  = "us-central1"


  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_node_pool" {
  name       = "${var.env}-node-pool"
  location   = "us-central1"
  cluster    = "${google_container_cluster.gke-cluster.name}"
  node_count = "1"

  node_config {
    preemptible   = true
    machine_type = "${var.machine_type}"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# RBAC ROLE PERMISSIONS
# ---------------------------------------------------------------------------------------------------------------------

# Create a ServiceAccount for Tiller
resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "tiller"
    namespace = "${local.tiller_namespace}"
  }

  depends_on = ["kubernetes_cluster_role_binding.tiller"]
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller"
  }

  subject {
    kind = "User"
    name = "system:serviceaccount:kube-system:tiller"
  }

  role_ref {
    kind  = "ClusterRole"
    name = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "helm_release" "consul" {
  name  = "consul"
  chart = "local/consul-helm"

  values = [
    "${file("/Users/dabenson/Workspace/terraform/terraform-gcp-gke/helm/helm-consul-values.yaml")}"
  ]

  depends_on = ["kubernetes_service_account.tiller"]
}

locals {
  # For this example, we hardcode our tiller namespace to kube-system. In production, you might want to consider using a
  # different Namespace.
  tiller_namespace = "kube-system"

  # For this example, we setup Tiller to manage the default Namespace.
  resource_namespace = "default"

  # We install an older version of Tiller to match the Helm library version used in the Terraform helm provider.
  tiller_version = "v2.11.0"

  # These will be filled in by the shell environment
  kubectl_auth_config = "--kubectl-server-endpoint \"$KUBECTL_SERVER_ENDPOINT\" --kubectl-certificate-authority \"$KUBECTL_CA_DATA\" --kubectl-token \"$KUBECTL_TOKEN\""
}
