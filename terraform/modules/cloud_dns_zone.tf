resource "google_dns_record_set" "default" {
    for_each = {
        for idx, config in flatten([
            for instance_name, instance_config in var.instance_properties: flatten([
                for dns_name, dns_config in instance_config.dns_records : {
                    name = dns_config.name
                    type = dns_config.type
                    ttl  = dns_config.ttl
                    instance_name = instance_name
                    forwarding_rule = dns_config.forwarding_rule
                    rrdatas = dns_config.rrdatas
                }
            ])
        ]) : idx => config
    }

    name         = each.value.name != "" ? "${each.value.name}.${data.google_dns_managed_zone.webapp-dns-zone.dns_name}" : data.google_dns_managed_zone.webapp-dns-zone.dns_name
    managed_zone = data.google_dns_managed_zone.webapp-dns-zone.name
    type         = each.value.type
    ttl          = each.value.ttl
    # rrdatas = each.value.type == "A" ? [google_compute_instance.webapp-instance[each.value.instance_name].network_interface[0].access_config[0].nat_ip] : each.value.rrdatas
    rrdatas = each.value.type == "A" ? [google_compute_global_forwarding_rule.default[each.value.forwarding_rule].ip_address] : each.value.rrdatas
    # rrdatas = each.value.rrdatas
    depends_on = [
        # google_compute_instance.webapp-instance
        google_compute_global_forwarding_rule.default
    ]
}
