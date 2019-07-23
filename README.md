# terraform-gke-helm-consul

## Prerequesites

1. Create ./creds/ folder.
2. Create service account on GCP and provide administrator priviliges, not editor, Administrator!
3. Download the json service account file and  store it on ./creds/ folder.
4. Install helm, kubectl, gloud and terraform locally on your machine.

##  Setup  with terraform

1. Run 'terraform init' to start and read all the providers
2. Run 'terraform plan'
3. Run 'terraform apply'


## Customize consul helm chart values

You can modify/add values at ./helm/helm-consul-values.yaml to customize the consul deployment.
