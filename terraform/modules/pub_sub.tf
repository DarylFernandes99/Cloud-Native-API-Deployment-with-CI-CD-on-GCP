resource "google_pubsub_schema" "default" {
    for_each = {
        for idx, config in flatten([
            for pub_sub_name, pub_sub_config in var.pub_sub_cloud_function: flatten([
                for schema_name, schema_config in pub_sub_config.schema : {
                    name = schema_config.name
                    type = schema_config.type
                    definition = schema_config.definition
                }
            ])
        ]) : idx => config
    }

    name = each.value.name
    type = each.value.type
    definition = each.value.definition
}

resource "google_pubsub_topic" "default" {
    for_each = var.pub_sub_cloud_function

    name                       = each.value.name
    # message_retention_duration = each.value.message_retention_duration
    schema_settings {
        schema = "projects/${var.project_id}/schemas/${each.value.schema_name}"
        encoding = each.value.schema_type
    }
    depends_on = [
        google_pubsub_schema.default
    ]
}

# resource "google_pubsub_subscription" "example" {
#     for_each = {
#         for idx, config in flatten([
#             for pub_sub_name, pub_sub_config in var.pub_sub_cloud_function: flatten([
#                 for cloud_function_name, cloud_function_config in pub_sub_config.cloud_function: flatten([
#                     for event_trigger_name, event_trigger_config in cloud_function_config.event_trigger : {
#                         name = event_trigger_config.name
#                         ack_deadline_seconds = event_trigger_config.ack_deadline_seconds
#                         message_retention_duration = event_trigger_config.message_retention_duration
#                         retain_acked_messages = event_trigger_config.retain_acked_messages
#                         service_account = event_trigger_config.service_account
#                         pub_sub_name = pub_sub_name
#                         cloud_function_name = cloud_function_name
#                     }
#                 ])
#             ])
#         ]) : idx => config
#     }
  
#     name  = each.value.name
#     topic = google_pubsub_topic.default[each.value.pub_sub_name].id

#     ack_deadline_seconds = each.value.ack_deadline_seconds
#     message_retention_duration = each.value.message_retention_duration
#     retain_acked_messages      = each.value.retain_acked_messages

#     push_config {
#         push_endpoint = google_cloudfunctions2_function.default[0].url
#         oidc_token {
#             # a new IAM service account is need to allow the subscription to trigger the function
#             service_account_email = google_service_account.default[each.value.service_account].email
#         }
#     }

#     depends_on = [
#         google_service_account.default,
#         google_cloudfunctions2_function.default
#     ]
# }
