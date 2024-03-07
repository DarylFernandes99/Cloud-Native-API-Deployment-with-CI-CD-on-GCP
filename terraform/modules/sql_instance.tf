resource "google_sql_database_instance" "sql_instance" {
    for_each = {
        for idx, config in flatten([
            for vpc_name, vpc_config in var.vpc_config: flatten([
                for sql_instance_name, sql_instance_config in vpc_config.sql_instance : {
                    # name: "${sql_instance_config.name}-${local.current_datetime}"
                    name: sql_instance_config.name
                    database_version: sql_instance_config.database_version
                    deletion_protection: sql_instance_config.deletion_protection
                    vpc_name: vpc_name
                    settings: sql_instance_config.settings
                }
            ])
        ]) : idx => config
    }

    name             = each.value.name
    database_version = each.value.database_version
    deletion_protection = each.value.deletion_protection

    depends_on = [
        google_service_networking_connection.private_access_connection
    ]

    dynamic "settings" {
        for_each = tolist([each.value.settings])

        content {
            tier = settings.value.tier
            disk_type = settings.value.disk_type
            disk_size = settings.value.disk_size
            availability_type = settings.value.availability_type

            location_preference {
                zone = var.zone
            }

            dynamic "ip_configuration" {
                for_each = tolist([settings.value.ip_configuration])
                
                content {
                    ipv4_enabled                                  = ip_configuration.value.ipv4_enabled
                    private_network                               = google_compute_network.vpc_network[each.value.vpc_name].id
                    enable_private_path_for_google_cloud_services = ip_configuration.value.enable_private_path_for_google_cloud_services
                }
            }

            dynamic "backup_configuration" {
                for_each = tolist([settings.value.backup_configuration])
                
                content {
                    binary_log_enabled = backup_configuration.value.binary_log_enabled
                    enabled            = backup_configuration.value.enabled
                }
            }
        }
    }
}

resource "google_sql_database" "sql_database" {
    for_each = {
        for idx, config in flatten([
            for vpc_name, vpc_config in var.vpc_config: flatten([
                for sql_instance_name, sql_instance_config in vpc_config.sql_instance: flatten([
                    for sql_database_name, sql_database_config in tolist([sql_instance_config.sql_database]) : {
                        name: sql_database_config.name
                        instance: google_sql_database_instance.sql_instance[0].name
                    }
                ])
            ])
        ]) : idx => config
    }

    name = each.value.name
    instance = each.value.instance
    depends_on = [
        google_sql_database_instance.sql_instance
    ]
    # charset = "utf8"
    # collation = "utf8_general_ci"
}

resource "random_password" "sql_password" {
    length  = 16
    override_special = "#"
    # special = false
    lower   = true
    upper   = true
}

resource "google_sql_user" "sql_user" {
    for_each = {
        for idx, config in flatten([
            for vpc_name, vpc_config in var.vpc_config: flatten([
                for sql_instance_name, sql_instance_config in vpc_config.sql_instance: flatten([
                    for sql_user_name, sql_user_config in tolist([sql_instance_config.sql_user]) : {
                        name: sql_user_config.name
                        host_instance_name: sql_user_config.host_instance_name
                        instance: google_sql_database_instance.sql_instance[0].name
                    }
                ])
            ])
        ]) : idx => config
    }

    name = each.value.name
    instance = each.value.instance
    # host = google_compute_instance.webapp-instance["${each.value.host_instance_name}-${local.current_datetime}"].id
    password = random_password.sql_password.result
}
