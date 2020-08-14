/******************************************
  Retrieve authentication token
 *****************************************/
data "google_client_config" "default" {
  provider = google
}

/******************************************
  Configure provider
 *****************************************/
provider "kubernetes" {
  version                = "~> 1.10, != 1.11.0"
  load_config_file       = false
  host                   = "https://${local.cluster_endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
}
