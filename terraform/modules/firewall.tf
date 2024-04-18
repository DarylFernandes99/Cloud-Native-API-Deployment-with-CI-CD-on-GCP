resource "google_compute_firewall" "firewall" {

    for_each = {
        for idx, config in flatten([
            for vpc_name, vpc_config in var.vpc_config: flatten([
				for firewall_name, firewall_config in vpc_config.firewalls : {
					"name"         : firewall_config.name
					"source_tags": firewall_config.source_tags
					"network"      : google_compute_network.vpc_network[vpc_name].id
					"allow" : firewall_config.allow
					"deny" : firewall_config.deny
					"source_ranges": firewall_config.source_ranges
				}
            ])
        ]) : idx => config
    }
    
	name    = each.value.name
    network = each.value.network
    source_tags = each.value.source_tags
    target_tags = each.value.source_tags
    source_ranges = each.value.source_ranges
	depends_on = [
		google_compute_network.vpc_network
	]

	dynamic "allow" {
		for_each = each.value.allow

		content {
			protocol = allow.value.protocol
			ports    = allow.value.ports
		}
	}

	dynamic "deny" {
		for_each = each.value.deny

		content {
			protocol = deny.value.protocol
			ports    = deny.value.ports
		}
	}
}
