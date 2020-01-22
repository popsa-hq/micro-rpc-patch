variable "resource_namespace" {
  description = "Shared resources kubernetes namespace"
  default     = "resource"
}

variable "domain_name" {
  description = "Domain name of the platform (e.g. micro.mu)"
  default     = "micro.mu"
}

variable "image_pull_policy" {
  description = "Kubernetes image pull policy for control plane deployments"
  default     = "Always"
}

variable "micro_image" {
  description = "Micro docker image"
  default     = "micro/micro"
}

variable "etcd_image" {
  description = "etcd docker image"
  default     = "gcr.io/etcd-development/etcd:v3.3.18"
}
