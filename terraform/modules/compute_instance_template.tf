resource "google_kms_crypto_key_iam_binding" "vm_crypto_key" {
    provider      = google-beta
    crypto_key_id = "${google_kms_crypto_key.key["vm_crypto_key1"].id}"
    # role          = "roles/owner"
    role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

    members = [
        "serviceAccount:service-${data.google_project.project.number}@compute-system.iam.gserviceaccount.com",
    ]
}

resource "google_kms_key_ring_iam_binding" "vm_key_ring" {
    provider      = google-beta
    key_ring_id = "${google_kms_key_ring.keyring["key1"].id}"
    # role        = "roles/owner"
    role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

    members = [
        "serviceAccount:service-${data.google_project.project.number}@compute-system.iam.gserviceaccount.com",
    ]
}

resource "google_compute_region_instance_template" "default" {
    for_each = var.instance_template_properties

    name           = each.value.name
    machine_type   = each.value.machine_type
    can_ip_forward = each.value.can_ip_forward
    region = var.region
    tags = each.value.tags
    labels = each.value.labels

    dynamic "disk" {
        for_each = tolist([each.value.disk])

        content {
            auto_delete = disk.value.auto_delete
            device_name = each.value.name
            mode = disk.value.mode
            source_image = disk.value.source_image
            disk_type = disk.value.disk_type
            disk_size_gb = disk.value.disk_size_gb

            disk_encryption_key {
                kms_key_self_link = google_kms_crypto_key.key[disk.value.cmek_account].id
            }
        }
    }

    dynamic "network_interface" {
      for_each = each.value.network_interface

      content {
        queue_count = network_interface.value.queue_count
        stack_type  = network_interface.value.stack_type
        # subnetwork  = network_interface.value.subnetwork
        subnetwork  = google_compute_subnetwork.subnets[0].id
        # network = google_compute_network.vpc_network.name

        dynamic "access_config" {
            for_each = tolist([network_interface.value.access_config])

            content {
              network_tier = access_config.value.network_tier
            }
        }
      }
    }
    
    dynamic "scheduling" {
        for_each = each.value.scheduling

        content {
            automatic_restart   = scheduling.value.automatic_restart
            on_host_maintenance = scheduling.value.on_host_maintenance
            preemptible         = scheduling.value.preemptible
            provisioning_model  = scheduling.value.provisioning_model
        }
      
    }

    dynamic "service_account" {
        for_each = each.value.service_account
        
        content {
            email  = google_service_account.default[service_account.value.service_account_name].email
            scopes = service_account.value.scopes
        }
    }

    dynamic "shielded_instance_config" {
        for_each = each.value.shielded_instance_config

        content {
            enable_integrity_monitoring = shielded_instance_config.value.enable_integrity_monitoring
            enable_secure_boot          = shielded_instance_config.value.enable_secure_boot
            enable_vtpm                 = shielded_instance_config.value.enable_vtpm
        }
    }
    
    metadata_startup_script = "${data.template_file.init.rendered}"

    depends_on = [
        google_kms_crypto_key.key,
        google_service_account.default,
        google_compute_subnetwork.subnets,
        google_sql_database_instance.sql_instance
    ]
}

# resource "google_compute_target_pool" "default" {
#     for_each = {
#         for idx, config in flatten([
#             for instance_template_name, instance_template_config in var.instance_template_properties: flatten([
#                 for instance_target_pool_name, instance_target_pool_config in instance_template_config.instance_target_pool : {
#                     "name"         : instance_target_pool_config.name
#                     "session_affinity"         : instance_target_pool_config.session_affinity
#                     "health_check_name": instance_target_pool_config.health_check_name
#                 }
#             ])
#         ]) : idx => config
#     }

#     name = each.value.name
#     session_affinity = each.value.session_affinity
#     # health_checks = each.value.health_check_name
# }

resource "google_compute_health_check" "default" {
    for_each = {
        for idx, config in flatten([
            for instance_template_name, instance_template_config in var.instance_template_properties: flatten([
                for health_check_name, health_check_config in instance_template_config.health_check : {
                    "name"         : health_check_config.name
                    "description"         : health_check_config.description
                    "timeout_sec"         : health_check_config.timeout_sec
                    "check_interval_sec"  : health_check_config.check_interval_sec
                    "healthy_threshold"   : health_check_config.healthy_threshold
                    "unhealthy_threshold" : health_check_config.unhealthy_threshold
                    "http_health_check" : health_check_config.http_health_check
                }
            ])
        ]) : idx => config
    }

    name        = each.value.name
    description = each.value.description

    timeout_sec         = each.value.timeout_sec
    check_interval_sec  = each.value.check_interval_sec
    healthy_threshold   = each.value.healthy_threshold
    unhealthy_threshold = each.value.unhealthy_threshold

    dynamic "http_health_check" {
        for_each = each.value.http_health_check

        content {
            port = http_health_check.value.port
            # port_name = http_health_check.value.port_name
            # port_specification = http_health_check.value.port_specification
            request_path       = http_health_check.value.request_path
            proxy_header       = http_health_check.value.proxy_header
            # response           = http_health_check.value.response
        }
    }
}

resource "google_compute_region_instance_group_manager" "default" {
    for_each = {
        for idx, config in flatten([
            for instance_template_name, instance_template_config in var.instance_template_properties: flatten([
                for instance_target_pool_name, instance_target_pool_config in instance_template_config.instance_target_pool : flatten([
                    for instance_group_manager_name, instance_group_manager_config in instance_target_pool_config.instance_group_manager : {
                        "name"         : instance_group_manager_config.name
                        "base_instance_name"         : instance_group_manager_config.base_instance_name
                        "auto_healing_policies"         : instance_group_manager_config.auto_healing_policies
                        "distribution_policy_zones"         : instance_group_manager_config.distribution_policy_zones
                        "instance_template_name": instance_template_name
                        "instance_target_pool_name": instance_group_manager_config.instance_target_pool_name
                        "named_port": instance_group_manager_config.named_port
                    }
                ])
            ])
        ]) : idx => config
    }

    name = each.value.name
    version {
        instance_template  = google_compute_region_instance_template.default[each.value.instance_template_name].self_link
        name               = "primary"
    }

    # target_pools       = [google_compute_target_pool.default[each.value.instance_target_pool_name].self_link]
    base_instance_name = each.value.base_instance_name
    distribution_policy_zones  = each.value.distribution_policy_zones

    dynamic "named_port" {
        for_each = each.value.named_port

        content {
          name = named_port.value.name
          port = named_port.value.port
        }
    }

    dynamic "auto_healing_policies" {
        for_each = each.value.auto_healing_policies

        content {
            health_check      = google_compute_health_check.default[auto_healing_policies.value.health_check].id
            initial_delay_sec = auto_healing_policies.value.initial_delay_sec
        }
    }

    depends_on = [
        # google_compute_target_pool.default,
        google_compute_health_check.default,
        google_compute_region_instance_template.default
    ]
}

# resource "google_compute_backend_service" "default" {
resource "google_compute_backend_service" "default" {
    for_each = {
        for idx, config in flatten([
            for instance_template_name, instance_template_config in var.instance_template_properties: flatten([
                for instance_target_pool_name, instance_target_pool_config in instance_template_config.instance_target_pool : flatten([
                    for instance_group_manager_name, instance_group_manager_config in instance_target_pool_config.instance_group_manager : flatten([
                        for backend_service_name, backend_service_config in instance_group_manager_config.backend_service : {
                            "name"         : backend_service_config.name
                            "protocol"         : backend_service_config.protocol
                            "instance_group_manager"         : backend_service_config.instance_group_manager
                            "health_check"         : backend_service_config.health_check
                            "load_balancing_scheme": backend_service_config.load_balancing_scheme
                            "locality_lb_policy"   : backend_service_config.locality_lb_policy
                            "backend"   : backend_service_config.backend
                            "port_name"   : backend_service_config.port_name
                            "log_config"   : backend_service_config.log_config
                        }
                    ])
                ])
            ])
        ]) : idx => config
    }

    name                    = each.value.name
    project = var.project_id
    provider                = google-beta
    # region = var.region
    health_checks           = [google_compute_health_check.default[each.value.health_check].id]

    protocol = each.value.protocol
    load_balancing_scheme = each.value.load_balancing_scheme
    locality_lb_policy    = each.value.locality_lb_policy
    port_name = each.value.port_name

    dynamic "backend" {
        for_each = each.value.backend

        content {
            group           = google_compute_region_instance_group_manager.default[each.value.instance_group_manager].instance_group
            balancing_mode  = backend.value.balancing_mode
            max_utilization = backend.value.max_utilization
        }
    }

    dynamic "log_config" {
        for_each = each.value.log_config
        
        content {
            enable = log_config.value.enable
        }
    }

    depends_on = [
        google_compute_health_check.default,
        google_compute_region_instance_group_manager.default
    ]
}
