# resource "google_compute_route" "webapp_route" {
#   name                   = "${var.name}-route"
#   network                = google_compute_network.webapp_vpc_network.self_link
#   dest_range             = "0.0.0.0/0"
#   next_hop_gateway       = google_compute_network.webapp_vpc_network.gateway_ipv4
#   tags                   = [ var.name ]
# }

# output "webapp_vpc_network_subnet_self_link" {
#   value = google_compute_subnetwork.webapp_vpc_network_subnet.self_link
# }

resource "google_compute_route" "routes" {
  for_each = {
    for idx, config in flatten([
      for vpc_name, vpc_config in var.vpc_config: flatten([
        for route_name, route_config in vpc_config.routes : {
          "name"             : route_config.name
          "network"          : google_compute_network.vpc_network[vpc_name].id
          "dest_range"       : route_config.dest_range
          "next_hop_gateway" : "https://www.googleapis.com/compute/v1/projects/${var.project_id}/global/gateways/default-internet-gateway"
          "tags"             : route_config.tags
        }
      ])
    ]) : idx => config
  }

  name                   = each.value.name
  network                = each.value.network
  dest_range             = each.value.dest_range
  next_hop_gateway       = each.value.next_hop_gateway
  tags                   = each.value.tags
  depends_on = [
    google_compute_network.vpc_network
  ]
}

output "routes" {
  value = google_compute_route.routes
}
