data "template_file" "init" {
  template = "${file("${path.module}/startup_script.sh")}"
  vars = {
    DB_USER     = google_sql_user.sql_user[0].name
    DB_PASSWORD = random_password.sql_password.result
    DB_DATABASE = google_sql_database.sql_database[0].name
    DB_HOST     = length(google_sql_database_instance.sql_instance[0].ip_address) > 0 ? google_sql_database_instance.sql_instance[0].ip_address[0].ip_address : null
  }

  depends_on = [
    google_sql_user.sql_user,
    google_sql_database.sql_database,
    google_sql_database_instance.sql_instance
  ]
}

resource "google_compute_instance" "webapp-instance" {
    for_each = var.instance_properties

    can_ip_forward      = each.value.can_ip_forward
    deletion_protection = each.value.deletion_protection
    enable_display      = each.value.enable_display
    machine_type = each.value.machine_type
    # name         = "${each.value.name}-${local.current_datetime}"
    name         = each.value.name
    zone = each.value.zone
    tags = each.value.tags

    labels = each.value.labels

    depends_on = [
      google_compute_subnetwork.subnets,
      google_sql_database_instance.sql_instance
    ]

    dynamic "boot_disk" {
      for_each = tolist([each.value.boot_disk])

      content {
        auto_delete = boot_disk.value.auto_delete
        # device_name = "${boot_disk.value.device_name}-${local.current_datetime}"
        device_name = each.value.name
        mode = boot_disk.value.mode

        dynamic "initialize_params" {
          for_each = tolist([boot_disk.value.initialize_params])

          content {
            image = initialize_params.value.image
            size  = initialize_params.value.size
            type  = initialize_params.value.type
          }
        }
      }
    }

    dynamic "network_interface" {
      for_each = each.value.network_interface

      content {
        queue_count = network_interface.value.queue_count
        stack_type  = network_interface.value.stack_type
        subnetwork  = network_interface.value.subnetwork

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
            email  = service_account.value.email
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
}
