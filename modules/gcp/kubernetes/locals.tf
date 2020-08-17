

/******************************************
  Get available zones in region
 *****************************************/
data "google_compute_zones" "available" {
  provider = google

  project = var.project_id
  region  = local.region
}

resource "random_shuffle" "available_zones" {
  input        = data.google_compute_zones.available.names
  result_count = 3
}

locals {
  node_group_service_account_roles = concat(var.additional_node_group_roles, [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer"
  ])

  node_group_oauth_scopes = concat(var.additional_node_group_oauth_scopes, [
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring"
  ])

}

/******************************************
  Get available container engine versions
 *****************************************/
data "google_container_engine_versions" "region" {
  location = local.location
  project  = var.project_id
}

data "google_container_engine_versions" "zone" {
  // Work around to prevent a lack of zone declaration from causing regional cluster creation from erroring out due to error
  //
  //     data.google_container_engine_versions.zone: Cannot determine zone: set in this resource, or set provider-level zone.
  //
  location = local.zone_count == 0 ? data.google_compute_zones.available.names[0] : var.zones[0]
  project  = var.project_id
}


locals {
  node_pools_labels = merge(
    { all = {} },
    { default-node-pool = {} },
    zipmap(
      [for node_pool in var.node_pools : node_pool["name"]],
      [for node_pool in var.node_pools : {}]
    ),
    var.node_pools_labels
  )

  node_pools_metadata = merge(
    { all = {} },
    { default-node-pool = {} },
    zipmap(
      [for node_pool in var.node_pools : node_pool["name"]],
      [for node_pool in var.node_pools : {}]
    ),
    var.node_pools_metadata
  )

  node_pools_tags = merge(
    { all = [] },
    { default-node-pool = [] },
    zipmap(
      [for node_pool in var.node_pools : node_pool["name"]],
      [for node_pool in var.node_pools : []]
    ),
    var.node_pools_tags
  )

  node_pools_oauth_scopes = merge(
    { all = ["https://www.googleapis.com/auth/cloud-platform"] },
    { default-node-pool = [] },
    zipmap(
      [for node_pool in var.node_pools : node_pool["name"]],
      [for node_pool in var.node_pools : []]
    ),
    var.node_pools_oauth_scopes
  )
}
