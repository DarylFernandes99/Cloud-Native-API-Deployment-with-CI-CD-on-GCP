locals {
  # https://www.packer.io/docs/templates/hcl_templates/functions/datetime/formatdate
  time      = formatdate("hhmm", timestamp())
  datestamp = formatdate("YYYYMMDD", timestamp())

  # https://www.packer.io/docs/templates/hcl_templates/functions/string/replace
  # because GCP image name cannot have '.' in its name
  image_webapp_version = replace(var.webapp_version, ".", "-")
}

# https://www.packer.io/docs/builders/googlecompute#required
source "googlecompute" "webapp-base" {
  project_id   = var.project_id
  zone         = var.zone
  machine_type = var.machine_type
  ssh_username = var.ssh_username
  use_os_login = var.use_os_login

  source_image_family = var.source_image_family
  image_name          = "webapp-${local.image_webapp_version}-base-${local.datestamp}-${local.time}"
  image_description   = "Webapp base image"

  tags = ["webapp"]
}
