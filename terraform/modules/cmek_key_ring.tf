resource "google_kms_key_ring" "keyring" {
    for_each = var.key_rings

    provider = google-beta
    name     = "${each.value.name}-${random_id.bucket_prefix.hex}"
    # name     = each.value.name
    location = var.region
    project = var.project_id
    # lifecycle {
    #     prevent_destroy = true
    # }
}

resource "google_kms_crypto_key" "key" {
    for_each = {
        for key_ring in flatten([
            for key_ring_name, key_ring_config in var.key_rings : [
                for kms_crypto_name, kms_crypto_config in key_ring_config.crypto_keys : {
                    kms_crypto_name = kms_crypto_name
                    kms_crypto_config = merge({key_ring_name=key_ring_name}, kms_crypto_config)
                }
            ]
        ]) : key_ring.kms_crypto_name => key_ring.kms_crypto_config
    }

    provider = google-beta
    name     = "${each.value.name}-${random_id.bucket_prefix.hex}"
    # name     = each.value.name
    key_ring = google_kms_key_ring.keyring[each.value.key_ring_name].id
    purpose  = each.value.purpose
    rotation_period = each.value.rotation_period
    depends_on = [
        google_kms_key_ring.keyring
    ]
    # lifecycle {
    #     prevent_destroy = true
    # }
}
