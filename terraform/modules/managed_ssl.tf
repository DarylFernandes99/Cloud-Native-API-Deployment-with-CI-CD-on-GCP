resource "google_compute_managed_ssl_certificate" "default" {
    for_each = var.ssl_details

    provider = google-beta
    project = var.project_id
    name     = each.value.name

    managed {
        domains = each.value.domain_name
    }
}

resource "google_compute_url_map" "default" {
    for_each = {
        for idx, config in flatten([
            for ssl_name, ssl_config in var.ssl_details: flatten([
                for url_map_name, url_map_config in ssl_config.url_map : {
                    name : url_map_config.name
                    description : url_map_config.description
                    backend_service : url_map_config.backend_service
                    host_rule : url_map_config.host_rule
                    path_matcher : url_map_config.path_matcher
                    hosts : ssl_config.domain_name
                }
            ])
        ]): idx => config
    }

    name        = each.value.name
    description = each.value.name

    default_service = google_compute_backend_service.default[each.value.backend_service].id

    # dynamic "host_rule" {
    #     for_each = each.value.host_rule

    #     content {
    #         hosts = each.value.hosts
    #         path_matcher = host_rule.value.path_matcher
    #     }
    # }

    # dynamic "path_matcher" {
    #     for_each = each.value.path_matcher

    #     content {
    #         name = path_matcher.value.name
    #         default_service = google_compute_backend_service.default[each.value.backend_service].id

    #         dynamic "path_rule" {
    #             for_each = path_matcher.value.path_rule

    #             content {
    #                 paths = path_rule.value.paths
    #                 service = google_compute_backend_service.default[each.value.backend_service].id
    #             }
    #         }
    #     }
    # }

    depends_on = [
        google_compute_backend_service.default
    ]
}

resource "google_compute_target_https_proxy" "default" {
    for_each = {
        for idx, config in flatten([
            for ssl_name, ssl_config in var.ssl_details: flatten([
                for url_map_name, url_map_config in ssl_config.url_map: flatten([
                    for https_proxy_name, https_proxy_config in url_map_config.https_proxy : {
                        name : https_proxy_config.name
                        url_map : https_proxy_config.url_map
                        ssl_name : ssl_name
                    }
                ])
            ])
        ]): idx => config
    }

    name             = each.value.name
    url_map          = google_compute_url_map.default[each.value.url_map].id
    ssl_certificates = [google_compute_managed_ssl_certificate.default[each.value.ssl_name].id]

    depends_on = [
        google_compute_url_map.default,
        google_compute_managed_ssl_certificate.default
    ]
}

resource "google_compute_global_forwarding_rule" "default" {
    for_each = {
        for idx, config in flatten([
            for ssl_name, ssl_config in var.ssl_details: flatten([
                for url_map_name, url_map_config in ssl_config.url_map: flatten([
                    for https_proxy_name, https_proxy_config in url_map_config.https_proxy: ([
                        for forwarding_rule_name, forwarding_rule_config in https_proxy_config.forwarding_rule : {
                            name : forwarding_rule_config.name
                            load_balancing_scheme : forwarding_rule_config.load_balancing_scheme
                            https_proxy : forwarding_rule_config.https_proxy
                            port_range : forwarding_rule_config.port_range
                        }
                    ])
                ])
            ])
        ]): idx => config
    }

    name       = each.value.name
    load_balancing_scheme = each.value.load_balancing_scheme
    target     = google_compute_target_https_proxy.default[each.value.https_proxy].id
    port_range = each.value.port_range

    depends_on = [
        google_compute_target_https_proxy.default,
        google_compute_global_address.private_ip_alloc
    ]
}
