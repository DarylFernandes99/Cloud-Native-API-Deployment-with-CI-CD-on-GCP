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
    }))

    routes = map(object({
      name       = string
      dest_range = string
      tags       = optional(list(string))
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
      })), {})
    }))

    sql_instance = optional(map(object({
      name                = string
      database_version    = string
      deletion_protection = bool

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
      email  = string
      scopes = list(string)
    }))

    shielded_instance_config = map(object({
      enable_integrity_monitoring = optional(bool, true)
      enable_secure_boot          = optional(bool, false)
      enable_vtpm                 = optional(bool, true)
    }))

  }))
}
