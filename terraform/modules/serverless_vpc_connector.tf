resource "google_vpc_access_connector" "connector" {
    for_each = {
        for idx, config in flatten([
            for vpc_name, vpc_config in var.vpc_config: flatten([
                for serverless_vpc_connector_name, serverless_vpc_connector_config in vpc_config.serverless_vpc_connector : {
                    name = serverless_vpc_connector_config.name
                    vpc_name = vpc_name
                    machine_type = serverless_vpc_connector_config.machine_type
                    min_instances = serverless_vpc_connector_config.min_instances
                    max_instances = serverless_vpc_connector_config.max_instances
                    ip_cidr_range = serverless_vpc_connector_config.ip_cidr_range
                }
            ])
        ]) : idx => config
    }

    name          = each.value.name
    network = google_compute_network.vpc_network[each.value.vpc_name].name
    machine_type = each.value.machine_type
    min_instances = each.value.min_instances
    max_instances = each.value.max_instances
    ip_cidr_range = each.value.ip_cidr_range

    depends_on = [
        google_compute_network.vpc_network
    ]
}
