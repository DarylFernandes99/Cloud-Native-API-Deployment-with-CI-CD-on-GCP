resource "google_compute_network" "vpc_network" {
  # name                            = "${var.name}-vpc"
  # auto_create_subnetworks         = var.auto_create_subnetworks
  # routing_mode                    = var.routing_mode
  # delete_default_routes_on_create = var.delete_default_routes_on_create
  for_each = var.vpc_config

  name                            = each.value.name
  auto_create_subnetworks         = each.value.auto_create_subnetworks
  routing_mode                    = each.value.routing_mode
  delete_default_routes_on_create = each.value.delete_default_routes_on_create
  mtu                             = each.value.mtu
}
