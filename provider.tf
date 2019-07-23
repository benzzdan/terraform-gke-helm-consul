provider "google" {
    credentials = "${file("./creds/terraform-service-account.json")}"
    project     = "terraform-247216"
    region      = "us-central1"

    scopes = [
        "https://www.googleapis.com/auth/userinfo.email",
        "https://www.googleapis.com/auth/compute",
        "https://www.googleapis.com/auth/cloud-platform",
        "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
        "https://www.googleapis.com/auth/devstorage.full_control"
    ]
}



