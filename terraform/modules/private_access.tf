########## Create Private Service Access:
resource "google_project_service" "service_networking" {
  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = true
}

resource "google_compute_global_address" "private_ip_alloc" {
    for_each = {
        for idx, config in flatten([
            for vpc_name, vpc_config in var.vpc_config: flatten([
                for private_access_name, private_access_config in vpc_config.private_access : {
                    name: private_access_config.name
                    purpose: private_access_config.purpose
                    address_type: private_access_config.address_type
                    prefix_length: private_access_config.prefix_length
                    network: google_compute_network.vpc_network[vpc_name].id
                }
            ])
        ]) : idx => config
    }
    
    name          = each.value.name
    purpose       = each.value.purpose
    address_type  = each.value.address_type
    prefix_length = each.value.prefix_length
    network       = each.value.network
}


########### Create a VPC Peering Connection:
resource "google_service_networking_connection" "private_access_connection" {
    for_each = {
        for idx, config in flatten([
            for vpc_name, vpc_config in var.vpc_config: flatten([
                for private_access_name, private_access_config in vpc_config.private_access : flatten([
                    for peering_connection_name, peering_connection_config in private_access_config.peering_connection : {
                        service : peering_connection_config.service
                        reserved_peering_ranges: [ google_compute_global_address.private_ip_alloc[0].name ]
                        network: google_compute_network.vpc_network[vpc_name].id
                        deletion_policy: peering_connection_config.deletion_policy
                    }
                ])
            ])
        ]) : idx => config
    }
    
    network                 = each.value.network
    service                 = each.value.service
    reserved_peering_ranges = each.value.reserved_peering_ranges
    deletion_policy         = each.value.deletion_policy
    depends_on = [
        google_compute_network.vpc_network,
        google_project_service.service_networking,
        google_compute_global_address.private_ip_alloc
    ]
}

resource "google_compute_network_peering_routes_config" "peering_routes" {
    for_each = {
        for idx, config in flatten([
            for vpc_name, vpc_config in var.vpc_config: flatten([
                for private_access_name, private_access_config in vpc_config.private_access : flatten([
                    for peering_connection_name, peering_connection_config in private_access_config.peering_connection : flatten([
                        for routes_name, routes_config in peering_connection_config.routes : {
                            vpc_network = vpc_name
                            import_custom_routes = routes_config.import_custom_routes
                            export_custom_routes = routes_config.export_custom_routes
                        }
                    ])
                ])
            ])
        ]) : idx => config
    }

  peering = google_service_networking_connection.private_access_connection[0].peering
  network = google_compute_network.vpc_network[each.value.vpc_network].name

  import_custom_routes = each.value.import_custom_routes
  export_custom_routes = each.value.export_custom_routes

  depends_on = [
    google_compute_network.vpc_network,
    google_service_networking_connection.private_access_connection
  ]
}
