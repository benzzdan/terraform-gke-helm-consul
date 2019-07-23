variable "region" {
  default     = "us-central1"
  description = "Google region to deploy cluster."
}

variable "zone" {
  default     = "us-central1-a"
  description = "The zone in which the cluster resides"
}

variable "env" {
  default     = "dev"
  description = "Environment name."
}

variable "cluster_size" {
  default     = 2
  description = "number of instances to be deployed in the node pool"
}

variable "machine_type" {
  default     = "n1-standard-1"
  description = "Instance type for the node pool"
}

variable "disk_size" {
  default     = 50
  description = "Size of the disk attached to each node specified in GB"
}

variable "disk_type" {
  default     = "pd-standard"
  description = "Type of the disk attached to each node."
}

variable "asg" {
  default     = false
  description = "Select wheter or not you want to deploy your node pool using autoscaling"
}

variable "min_instance" {
  default     = 1
  description = "Min number of mashines to be deployed withing asg"
}

variable "max_instance" {
  default     = 3
  description = "Min number of mashines to be deployed withing asg"
}
