resource "google_secret_manager_secret" "default" {
    for_each = local.secrets

    project   = var.project_id
    secret_id = each.key

    replication {
        auto {}
    }
}

# Creating secret version with service account key
resource "google_secret_manager_secret_version" "default" {
    for_each = local.secrets
    
    secret = google_secret_manager_secret.default[each.key].id

    # secret_data = filebase64("${data.template_file.init.rendered}")
    secret_data = each.value

    depends_on = [
        google_compute_region_instance_template.default
    ]
}
