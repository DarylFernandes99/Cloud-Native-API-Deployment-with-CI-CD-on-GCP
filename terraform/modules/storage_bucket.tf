resource "google_kms_crypto_key_iam_binding" "storage_crypto_key" {
    provider      = google-beta
    crypto_key_id = "${google_kms_crypto_key.key["storage_bucket_crypto"].id}"
    # role          = "roles/owner"
    role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

    members = [
        "serviceAccount:service-${data.google_project.project.number}@gs-project-accounts.iam.gserviceaccount.com",
    ]
}

resource "google_storage_bucket" "default" {
    name                        = "${var.bucket_name}-${random_id.bucket_prefix.hex}"
    location                    = "US-EAST1"
    uniform_bucket_level_access = true
    encryption {
        default_kms_key_name = google_kms_crypto_key.key["storage_bucket_crypto"].id
    }

    depends_on = [
        google_kms_crypto_key_iam_binding.storage_crypto_key
    ]
}

resource "google_storage_bucket_object" "default" {
    name   = "${var.bucket_object_path}"
    bucket = google_storage_bucket.default.name
    source = "${path.module}/${var.bucket_object_path}"

    depends_on = [
        google_storage_bucket.default
    ]
}

# data "google_storage_bucket" "default" {
#     name = var.bucket_name

#     depends_on = [
#         google_kms_crypto_key.key
#     ]
# }

# data "google_storage_bucket_object" "default" {
#     bucket = data.google_storage_bucket.default.name
#     name = var.bucket_object_path
# }
