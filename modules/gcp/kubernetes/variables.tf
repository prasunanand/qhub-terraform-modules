variable "name" {
  description = "Prefix name for GCP Kubernetes cluster"
  type        = string
}

variable "description" {
  type        = string
  description = "The description of the cluster"
  default     = ""
}

variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in (required)"
}

variable "regional" {
  type        = bool
  description = "Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!)"
  default     = true
}

variable "region" {
  type        = string
  description = "The region to host the cluster in (optional if zonal cluster / required if regional)"
  default     = null
}

variable "cluster_resource_labels" {
  type        = map(string)
  description = "The GCE resource labels (a map of key/value pairs) to be applied to the cluster"
  default     = {}
}

variable "cluster_ipv4_cidr" {
  default     = null
  description = "The IP address range of the kubernetes pods in this cluster. Default is an automatically assigned CIDR."
}

variable "logging_service" {
  type        = string
  description = "The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none"
  default     = "logging.googleapis.com/kubernetes"
}

variable "monitoring_service" {
  type        = string
  description = "The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none"
  default     = "monitoring.googleapis.com/kubernetes"
}

variable "default_max_pods_per_node" {
  description = "The maximum number of pods to schedule per node"
  default     = 110
}

# authentication

variable "basic_auth_username" {
  type        = string
  description = "The username to be used with Basic Authentication. An empty value will disable Basic Authentication, which is the recommended configuration."
  default     = ""
}

variable "basic_auth_password" {
  type        = string
  description = "The password to be used with Basic Authentication."
  default     = ""
}

variable "issue_client_certificate" {
  type        = bool
  description = "Issues a client certificate to authenticate to the cluster endpoint. To maximize the security of your cluster, leave this option disabled. Client certificates don't automatically rotate and aren't easily revocable. WARNING: changing this after cluster creation is destructive!"
  default     = false
}

# load balancing
variable "http_load_balancing" {
  type        = bool
  description = "Enable httpload balancer addon"
  default     = true
}


variable "horizontal_pod_autoscaling" {
  type        = bool
  description = "Enable horizontal pod autoscaling addon"
  default     = true
}

variable "network_policy" {
  type        = bool
  description = "Enable network policy addon"
  default     = true
}

variable "ip_range_pods" {
  type        = string
  description = "The _name_ of the secondary subnet ip range to use for pods"
}

variable "ip_range_services" {
  type        = string
  description = "The _name_ of the secondary subnet range to use for services"
}

variable "maintenance_start_time" {
  type        = string
  description = "Time window specified for daily or recurring maintenance operations in RFC3339 format"
  default     = "05:00"
}

variable "enable_private_nodes" {
  type        = bool
  description = "(Beta) Whether nodes have internal IP addresses only"
  default     = false
}

variable "enable_private_endpoint" {
  type        = bool
  description = "(Beta) Whether the master's internal IP address is used as the cluster endpoint"
  default     = false
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "(Beta) The IP range in CIDR notation to use for the hosted master network"
  default     = "10.0.0.0/28"
}

variable "availability_zones" {
  description = "Zones for Kubernetes cluster to be deployed in"
  type        = list(string)
}

variable "location" {
  description = "Location for GCP Kubernetes cluster"
  type        = string
}

variable "additional_node_group_roles" {
  description = "Additional roles to apply to each node group"
  type        = list(string)
  default     = []
}

variable "additional_node_group_oauth_scopes" {
  description = "Additional oauth scopes to apply to each node group"
  type        = list(string)
  default     = []
}

variable "node_groups" {
  description = "Node groups to add to GCP Kubernetes Cluster"
  type = list(object({
    name          = string
    instance_type = string
    min_size      = number
    max_size      = number
  }))
}

# difference here qhub uses node_pools whereas tgm uses node_pools
variable "node_pools" {
  type        = list(map(string))
  description = "List of maps containing node pools"

  default = [
    {
      name = "default-node-pool"
    },
  ]
}

variable "gcloud_upgrade" {
  type        = bool
  description = "Whether to upgrade gcloud at runtime"
  default     = false
}

variable "gcloud_skip_download" {
  type        = bool
  description = "Whether to skip downloading gcloud (assumes gcloud is already available outside the module)"
  default     = true
}

variable "network_project_id" {
  type        = string
  description = "The project ID of the shared VPC's host (for shared vpc support)"
  default     = ""
}

variable "network_policy_provider" {
  type        = string
  description = "The network policy provider."
  default     = "CALICO"
}

variable "zones" {
  type        = list(string)
  description = "The zones to host the cluster in (optional if regional cluster / required if zonal)"
  default     = []
}

variable "stub_domains" {
  type        = map(list(string))
  description = "Map of stub domains and their resolvers to forward DNS queries for a certain domain to an external DNS server"
  default     = {}
}

variable "upstream_nameservers" {
  type        = list(string)
  description = "If specified, the values replace the nameservers taken by default from the node’s /etc/resolv.conf"
  default     = []
}

variable "master_authorized_networks" {
  type        = list(object({ cidr_block = string, display_name = string }))
  description = "List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists)."
  default     = []
}
