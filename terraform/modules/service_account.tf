resource "google_service_account" "default" {
    for_each = var.service_account
    
    account_id   = each.value.account_id
    display_name = upper(each.value.account_id)
    create_ignore_already_exists = true
}

resource "google_project_iam_binding" "project" {
    for_each = {
        for idx, config in flatten([
            for service_account_name, service_account_roles in var.service_account : [
                for role in service_account_roles.roles : {
                    role                 = role
                    service_account_name = service_account_name
                }
            ]
        ]) : idx => config
    }

    role    = each.value.role
    project = var.project_id
    members  = [
        "serviceAccount:${google_service_account.default[each.value.service_account_name].email}"
    ]
    depends_on = [
        google_service_account.default
    ]
}

# resource "google_kms_crypto_key_iam_binding" "service_account_crypto_key" {
#     for_each = { for key, val in var.service_account : key => val if val.cmek_keys }

#     provider      = google-beta
#     crypto_key_id = google_kms_crypto_key.key[each.value.cmek_account].id
#     role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
#     members = [
#         "serviceAccount:${google_service_account.default[each.key].email}",
#     ]
#     depends_on = [
#         google_kms_crypto_key.key,
#         google_service_account.default
#     ]
# }
