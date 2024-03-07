# resource "google_compute_subnetwork" "webapp_vpc_network_subnet" {
#   name                            = "${var.name}"
#   ip_cidr_range = var.subnet_cidr_range
#   region        = var.region
#   network       = google_compute_network.webapp_vpc_network.id
# }

# resource "google_compute_subnetwork" "db_vpc_network_subnet" {
#   name                            = "db"
#   ip_cidr_range = var.subnet_cidr_range
#   region        = var.region
#   network       = google_compute_network.webapp_vpc_network.id
# }

resource "google_compute_subnetwork" "subnets" {
  for_each = {
    for idx, config in flatten([
      for vpc_name, vpc_config in var.vpc_config: flatten([
        for subnet_name, subnet_config in vpc_config.subnets : {
          "name"         : subnet_config.name
          "ip_cidr_range": subnet_config.ip_cidr_range
          "network"      : google_compute_network.vpc_network[vpc_name].id
        }
      ])
    ]) : idx => config
  }

  name          = each.value.name
  ip_cidr_range = each.value.ip_cidr_range
  network       = each.value.network
  depends_on = [
    google_compute_network.vpc_network
  ]
}
