resource "google_cloudfunctions2_function" "default" {
    for_each = {
        for idx, config in flatten([
            for pub_sub_name, pub_sub_config in var.pub_sub_cloud_function: flatten([
                for cloud_function_name, cloud_function_config in pub_sub_config.cloud_function : {
                    name = cloud_function_config.name
                    description = cloud_function_config.description
                    build_config = cloud_function_config.build_config
                    service_config = cloud_function_config.service_config
                    pub_sub_name = pub_sub_name
                    event_trigger = cloud_function_config.event_trigger
                }
            ])
        ]) : idx => config
    }

    name        = each.value.name
    location    = var.region
    description = each.value.description
    depends_on = [
        google_service_account.default,
        google_pubsub_topic.default,
        google_sql_database_instance.sql_instance,
        google_sql_database.sql_database,
        google_sql_user.sql_user,
        google_vpc_access_connector.connector
    ]

    dynamic "build_config" {
        for_each = each.value.build_config

        content {
            runtime = build_config.value.runtime
            entry_point = build_config.value.entry_point
            environment_variables = merge(build_config.value.environment_variables, local.environment_variables)
            source {
                storage_source {
                    bucket = google_storage_bucket.default.name
                    object = google_storage_bucket_object.default.name
                    # bucket = data.google_storage_bucket.default.name
                    # object = data.google_storage_bucket_object.default.name
                }
            }
        }
    }

    dynamic "service_config" {
        for_each = each.value.service_config

        content {
            max_instance_count = service_config.value.max_instance_count
            min_instance_count = service_config.value.min_instance_count
            available_memory   = service_config.value.available_memory
            timeout_seconds    = service_config.value.timeout_seconds
            environment_variables = merge(service_config.value.environment_variables, local.environment_variables)
            ingress_settings               = service_config.value.ingress_settings
            vpc_connector_egress_settings  = service_config.value.vpc_connector_egress_settings
            vpc_connector     = google_vpc_access_connector.connector[service_config.value.vpc_connector].name
            all_traffic_on_latest_revision = service_config.value.all_traffic_on_latest_revision
            service_account_email          = google_service_account.default[service_config.value.service_account].email
        }
    }

    dynamic "event_trigger" {
        for_each = each.value.event_trigger

        content {
            event_type = event_trigger.value.event_type
            pubsub_topic   = google_pubsub_topic.default[each.value.pub_sub_name].id
            retry_policy = event_trigger.value.retry_policy
        }
    }
}
