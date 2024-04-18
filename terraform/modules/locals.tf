locals {
  current_datetime = formatdate("YYYYMMDD-hhmm", timestamp())
}

locals {
  environment_variables = {
    SQLALCHEMY_DATABASE_URI_DEV = "mysql://${google_sql_user.sql_user[0].name}:${random_password.sql_password.result}@${length(google_sql_database_instance.sql_instance[0].ip_address) > 0 ? google_sql_database_instance.sql_instance[0].ip_address[0].ip_address : null}:3306/${google_sql_database.sql_database[0].name}"
  }

  depends_on = [
    google_sql_user.sql_user,
    google_sql_database.sql_database,
    google_sql_database_instance.sql_instance
  ]
}

locals {
  secrets = merge({
    "webapp-startup-script" = "${data.template_file.init.rendered}"
    "webapp-kms-key" = "webapp-key-ring-test-${local.current_datetime} webapp-vm-crypto-key-test-${local.current_datetime}"
  }, var.secrets)
}

resource "random_id" "bucket_prefix" {
  byte_length = 8
}

data "template_file" "init" {
  template = "${file("${path.module}/startup_script.sh")}"
  vars = {
    DB_USER     = google_sql_user.sql_user[0].name
    DB_PASSWORD = random_password.sql_password.result
    DB_DATABASE = google_sql_database.sql_database[0].name
    DB_HOST     = length(google_sql_database_instance.sql_instance[0].ip_address) > 0 ? google_sql_database_instance.sql_instance[0].ip_address[0].ip_address : null
    TOPIC_NAME  = google_pubsub_topic.default["email_verification"].name
  }

  depends_on = [
    google_sql_user.sql_user,
    google_pubsub_topic.default,
    google_sql_database.sql_database,
    google_sql_database_instance.sql_instance
  ]
}

data "google_dns_managed_zone" "webapp-dns-zone" {
    name = var.dns_name
}

data "google_project" "project" {
  project_id = var.project_id
}
