variable "name" {
  description = "Prefix in resource name"
  type        = string
}

variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "region" {
  description = "Region in which the infrastructure should be created"
  type        = string
}

variable "zone" {
  description = "Zone in which the infrastructure should be created"
  type        = string
}

variable "vpc_config" {
  description = "Configuration(s) for VPC"
  type = map(object({
    name                            = string
    auto_create_subnetworks         = bool
    routing_mode                    = string
    delete_default_routes_on_create = bool
    mtu                             = optional(number, 1460)

    subnets = map(object({
      name          = string
      ip_cidr_range = string
      purpose       = optional(string, "PRIVATE_RFC_1918")
      role          = optional(string, null)
    }))

    routes = map(object({
      name       = string
      dest_range = string
      tags       = optional(list(string), [])
    }))

    firewalls = map(object({
      name          = string
      source_tags   = list(string)
      source_ranges = optional(list(string), [])
      allow = optional(list(object({
        protocol = string
        ports    = optional(list(string), [])
      })), [])
      deny = optional(list(object({
        protocol = string
        ports    = optional(list(string), [])
      })), [])
    }))

    private_access = map(object({
      name          = string
      purpose       = string
      address_type  = string
      prefix_length = number

      peering_connection = optional(map(object({
        service         = string
        deletion_policy = string

        routes = map(object({
          import_custom_routes = optional(bool, false)
          export_custom_routes = optional(bool, false)
        }))
      })), {})
    }))

    serverless_vpc_connector = optional(map(object({
      name          = string
      machine_type  = string
      min_instances = number
      max_instances = number
      ip_cidr_range = string
    })), {})

    sql_instance = optional(map(object({
      name                = string
      database_version    = string
      deletion_protection = bool
      cmek_account        = optional(string, null)

      settings = object({
        tier              = string
        disk_type         = optional(string, "PD_SSD")
        disk_size         = number
        availability_type = optional(string, "ZONAL")

        ip_configuration = object({
          ipv4_enabled                                  = bool
          enable_private_path_for_google_cloud_services = optional(bool, false)
        })

        backup_configuration = object({
          binary_log_enabled = bool
          enabled            = bool
        })
      })

      sql_database = object({
        name = string
      })

      sql_user = object({
        name               = string
        host_instance_name = string
      })
    })), {})

  }))
}

variable "dns_name" {
  description = "Existing zone name"
  type        = string
}

variable "key_rings" {
  description = "CMEK keys"
  type = map(object({
    name = string
    crypto_keys = map(object({
      name            = string
      purpose         = optional(string, "ENCRYPT_DECRYPT")
      rotation_period = optional(string, "86400s")
    }))
  }))
}

variable "service_account" {
  description = "Service account to be created with the IAM roles"
  type = map(object({
    account_id   = string
    roles        = list(string)
    cmek_keys    = optional(bool, false)
    cmek_account = optional(string, null)
  }))
}

variable "secrets" {
  description = "Secrets stored in Google Cloud"
  type        = map(string)
}

variable "instance_properties" {
  description = "Configuration(s) for VMs"
  type = map(object({
    can_ip_forward      = optional(bool, false)
    deletion_protection = optional(bool, false)
    enable_display      = optional(bool, false)
    machine_type        = string
    name                = string
    zone                = string
    tags                = list(string)

    boot_disk = object({
      auto_delete = optional(bool, true)
      device_name = string
      mode        = optional(string, "READ_WRITE")

      initialize_params = object({
        image = string
        size  = optional(number, 20)
        type  = optional(string, "pd-balanced")
      })
    })

    labels = object({
      goog-ec-src = optional(string, "vm_add-tf")
    })

    network_interface = map(object({
      access_config = object({
        network_tier = optional(string, "PREMIUM")
      })

      queue_count = optional(number, 0)
      stack_type  = optional(string, "IPV4_ONLY")
      subnetwork  = optional(string, "")
    }))

    scheduling = map(object({
      automatic_restart   = optional(bool, true)
      on_host_maintenance = optional(string, "MIGRATE")
      preemptible         = optional(bool, false)
      provisioning_model  = optional(string, "STANDARD")
    }))

    service_account = map(object({
      service_account_name = string
      scopes               = list(string)
    }))

    shielded_instance_config = map(object({
      enable_integrity_monitoring = optional(bool, true)
      enable_secure_boot          = optional(bool, false)
      enable_vtpm                 = optional(bool, true)
    }))

    dns_records = optional(map(object({
      name            = optional(string, "")
      type            = string
      ttl             = optional(number, 300)
      forwarding_rule = optional(number, null)
      rrdatas         = optional(list(string), [])
    })), {})

  }))
}

variable "bucket_name" {
  description = "Google Storage Bucket name"
  type        = string
}

variable "bucket_object_path" {
  description = "Bucket path of the object"
  type        = string
}

variable "pub_sub_cloud_function" {
  description = "Pub/Sub configuration with cloud function trigger"
  type = map(object({
    name = string,
    # Minimum is 10 minutes, maximum is 31 days
    message_retention_duration = optional(string, "36000s")
    schema_name                = string
    schema_type                = string

    schema = optional(map(object({
      name       = string
      type       = optional(string, "AVRO")
      definition = string
    })), {})

    cloud_function = optional(map(object({
      name        = string
      description = optional(string, "")
      build_config = map(object({
        runtime               = string
        entry_point           = string
        environment_variables = optional(map(string), {})
        # source = optional(object({
        #   storage_source = optional(object({
        #   }), {})
        # }), {})
      }))
      service_config = map(object({
        min_instance_count             = optional(number, 0)
        max_instance_count             = optional(number, 1)
        available_memory               = optional(string, "256M")
        timeout_seconds                = optional(number, 60)
        environment_variables          = optional(map(string), {})
        ingress_settings               = optional(string, "ALLOW_ALL")
        vpc_connector                  = number
        vpc_connector_egress_settings  = optional(string, "ALL_TRAFFIC")
        service_account                = string
        all_traffic_on_latest_revision = optional(bool, true)
      }))
      event_trigger = map(object({
        event_type   = string
        retry_policy = optional(string, "RETRY_POLICY_UNSPECIFIED")
        # name = string
        # service_account                = string
        # ack_deadline_seconds = number
        # message_retention_duration = string
        # retain_acked_messages      = bool
      }))
    })), {})

  }))
}

variable "ssl_details" {
  description = "SSL details"
  type = map(object({
    name        = string
    domain_name = list(string)

    url_map = map(object({
      name            = string
      description     = optional(string, "No description")
      backend_service = number

      host_rule = map(object({
        path_matcher = string
      }))

      path_matcher = map(object({
        name = string
        path_rule = map(object({
          paths = list(string)
        }))
      }))

      https_proxy = map(object({
        name    = string
        url_map = number
        forwarding_rule = map(object({
          name                  = string
          https_proxy           = number
          port_range            = number
          load_balancing_scheme = string
        }))
      }))
    }))
  }))
}

variable "instance_template_properties" {
  description = "Configuration(s) for VMs"
  type = map(object({
    can_ip_forward = optional(bool, false)
    # deletion_protection = optional(bool, false)
    # enable_display      = optional(bool, false)
    machine_type = string
    name         = string
    # zone                = string
    tags = list(string)

    disk = object({
      auto_delete  = optional(bool, true)
      device_name  = string
      mode         = optional(string, "READ_WRITE")
      source_image = string
      disk_size_gb = optional(number, 20)
      disk_type    = optional(string, "pd-balanced")
      cmek_account = optional(string, null)
    })

    labels = object({
      goog-ec-src = optional(string, "vm_add-tf")
    })

    network_interface = map(object({
      access_config = object({
        network_tier = optional(string, "PREMIUM")
      })

      queue_count = optional(number, 0)
      stack_type  = optional(string, "IPV4_ONLY")
      subnetwork  = optional(string, "")
    }))

    scheduling = map(object({
      automatic_restart   = optional(bool, true)
      on_host_maintenance = optional(string, "MIGRATE")
      preemptible         = optional(bool, false)
      provisioning_model  = optional(string, "STANDARD")
    }))

    service_account = map(object({
      service_account_name = string
      scopes               = list(string)
    }))

    shielded_instance_config = map(object({
      enable_integrity_monitoring = optional(bool, true)
      enable_secure_boot          = optional(bool, false)
      enable_vtpm                 = optional(bool, true)
    }))

    # dns_records = optional(map(object({
    #   name    = optional(string, "")
    #   type    = string
    #   ttl     = optional(number, 300)
    #   rrdatas = optional(list(string), [])
    # })), {})

    health_check = map(object({
      name                = string
      description         = optional(string, "No description")
      timeout_sec         = optional(number, 5)
      check_interval_sec  = optional(number, 5)
      healthy_threshold   = optional(number, 2)
      unhealthy_threshold = optional(number, 2)

      http_health_check = map(object({
        port               = string
        port_name          = string
        port_specification = string
        request_path       = string
        proxy_header       = optional(string, "NONE")
      }))
    }))

    instance_target_pool = map(object({
      name              = string
      session_affinity  = string
      health_check_name = list(string)
      instance_group_manager = map(object({
        name                      = string
        base_instance_name        = string
        instance_target_pool_name = number
        distribution_policy_zones = list(string)

        named_port = map(object({
          name = string
          port = number
        }))

        auto_healing_policies = map(object({
          health_check      = number
          initial_delay_sec = number
        }))

        backend_service = map(object({
          name                   = string
          load_balancing_scheme  = string
          locality_lb_policy     = string
          port_name              = string
          health_check           = number
          instance_group_manager = number
          protocol               = string

          backend = map(object({
            balancing_mode  = string
            max_utilization = number
          }))

          log_config = map(object({
            enable = bool
          }))
        }))

        autoscaler = map(object({
          name = string
          autoscaling_policy = map(object({
            max_replicas           = optional(number, 1)
            min_replicas           = optional(number, 0)
            cooldown_period        = optional(number, 60)
            cpu_utilization_target = number
          }))
          instance_group_manager_name = number
        }))
      }))
    }))

  }))
}
